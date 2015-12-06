require 'net/telnet'
module IllegalBoss
    module Spider
      # require 'illegal_boss'
    # IllegalBoss::Spider::Ptt
    # Your code goes here...
    attr_reader :records
    class Ptt
      AnsiSetDisplayAttr = '\x1B\[(?>(?>(?>\d+;)*\d+)?)m'
      WaitForInput =  '(?>\s+)(?>\x08+)'
      AnsiEraseEOL = '\x1B\[K'
      AnsiCursorHome = '\x1B\[(?>(?>\d+;\d+)?)H'
      PressAnyKey = '\xAB\xF6\xA5\xF4\xB7\x4E\xC1\xE4\xC4\x7E\xC4\xF2'
      Big5Code = '[\xA1-\xF9][\x40-\xF0]'
      PressAnyKeyToContinue = "#{PressAnyKey}(?>\\s*)#{AnsiSetDisplayAttr}" + '(?>(?:\\xA2\\x65)+)\s*' + "#{AnsiSetDisplayAttr}"
      PressAnyKeyToContinue2 = "\\[#{PressAnyKey}\\](?>\\s*)#{AnsiSetDisplayAttr}"
      # (b)進板畫面
      ArticleList = '\(b\)' + "#{AnsiSetDisplayAttr}" + '\xB6\x69\xAA\x4F\xB5\x65\xAD\xB1\s*' + "#{AnsiSetDisplayAttr}#{AnsiCursorHome}"
      Signature = '\xC3\xB1\xA6\x57\xC0\xC9\.(?>\d+).+' + "#{AnsiCursorHome}"
      EmailBox = '[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}'

      def initialize(attributes = {})
        p "connect"
        p "ptt_login"
        tn = ptt_connect(23) 
        # ptt_login(tn, ' mafiapatch', '000000')
        ptt_login(tn, ' birdchiu', '74108520')
        p "DONE"
        # 進入O2
        ptt_board(tn, 'AllTogether')  
        p "ptt_board"
        # 搜尋標題:
        result = search_by_promote(tn, '-10')  
        gsub_ansi_by_space(result)  
        authors = get_article_author_list(result) 
        # 只取最新 10 筆
        authors.reverse!
        if authors.size > 10
          authors.slice!(10, authors.size - 10)
        end
        p "goto_by_article_num"
                  goto_by_article_num(tn, 159)

                tn.waitfor(/\xBA\xF4\xA7\x7D:(?>\s*)\Z/n){ |s| print(s) }

        # 將最新10筆徵友文寄回信箱
        authors.each do |a|   
          goto_by_article_num(tn, a[0])
          # if !email_article(tn, ARGV[2])
          #   puts('\nsend article #{a[0]} fail!')
          # end
        end
        # @records = json_to_array
      rescue Exception => err
        puts(err.to_s())
        err.backtrace.each{ |s| puts(s) }
      end

      private

      def fff
        tn = ptt_connect(23)
        tn.waitfor(/guest.+new(?>[^:]+):(?>\s*)#{AnsiSetDisplayAttr}#{WaitForInput}\Z/){ |s| print(s) } 
        tn.cmd('String' => ' mafiapatch', 'Match' => /\xB1\x4B\xBD\x58:(?>\s*)\Z/n){ |s| print(s) }
        tn.cmd('String' => '000000', 
             'Match' => /#{PressAnyKeyToContinue}\Z/n){ |s| print(s) }
        tn.print('\n')
        tn.print('s')
        tn.print('q')

      end

      def ptt_connect(port, time_out=3, wait_time=1)
        raise ArgumentError, 'ptt_connect invalid arg 0:' unless port.kind_of? Integer
        raise ArgumentError, 'ptt_connect() invalid arg 1:' unless time_out.kind_of? Integer
        raise ArgumentError, 'ptt_connect() invalid arg 2:' unless wait_time.kind_of? Integer
        begin
          tn = Net::Telnet.new('Host'       => 'ptt.cc',
                               'Port'       => port,
                               'Timeout'    => time_out,
                               'Waittime'   => wait_time
                               )


        rescue SystemCallError => e
          raise e, 'ptt_connect() system call:' + e.to_s()
        rescue TimeoutError => e
          raise e, 'ptt_connect() timeout:' + e.to_s()
        rescue SocketError => e
          raise e, 'ptt_connect() socket:' + e.to_s()
        rescue Exception => e
          raise e, 'ptt_connect() unknown:' + e.to_s()
        end
        return tn
      end

      def ptt_login(tn, id, password)
        raise ArgumentError, 'ptt_login() invalid telnet reference:' unless tn.kind_of? Net::Telnet
        raise ArgumentError, 'ptt_login() invalid id:' unless id.kind_of? String
        raise ArgumentError, 'ptt_login() invalid password:' unless password.kind_of? String
        # tn = ptt_connect(23)
        begin
          tn.waitfor(/guest.+new(?>[^:]+):(?>\s*)#{AnsiSetDisplayAttr}#{WaitForInput}\Z/){ |s| print(s) }  
          tn.cmd('String' => id, 'Match' => /\xB1\x4B\xBD\x58:(?>\s*)\Z/n){ |s| print(s) }
          tn.cmd('String' => password, 
               'Match' => /#{PressAnyKeyToContinue}\Z/n){ |s| print(s) }
          tn.print('\n')
          tn.print('s')
          tn.print('q')
        rescue SystemCallError => e
          raise e, 'ptt_login() system call:' + e.to_s()
        rescue TimeoutError => e
          raise e, 'ptt_login() timeout:' + e.to_s()
        rescue SocketError => e        
          raise e, 'ptt_login() socket:' + e.to_s()    
        rescue Exception => e
          raise e, 'ptt_login() unknown:' + e.to_s()      
        end
      end

      # ptt_board(tn, 'AllTogether') 
      def ptt_board(tn, board_name)
        raise ArgumentError, 'ptt_board() invalid telnet reference:' unless tn.kind_of? Net::Telnet
          raise ArgumentError, 'ptt_board() invalid id:' unless board_name.kind_of? String
          
        begin
          # [caller]
          tn.waitfor(/\[\xA9\x49\xA5\x73\xBE\xB9\]#{AnsiSetDisplayAttr}.+#{AnsiCursorHome}\Z/n){ |s| print(s) }    
          tn.print('s')
          tn.waitfor(/\):(?>\s*)#{AnsiSetDisplayAttr}(?>\s*)#{AnsiSetDisplayAttr}#{AnsiCursorHome}\Z/){ |s| print(s) }    
          
          lines = tn.cmd( 'String' => 'job', 'Match' => /(?>#{PressAnyKeyToContinue}|#{ArticleList})\Z/n ) do |s|       
            print(s)
          end   
          
          # continue
          if not (/#{PressAnyKeyToContinue}\Z/n =~ lines)
            return lines
          end   
          
          
          lines = tn.cmd('String' => '', 'Match' => /#{ArticleList}\Z/n) do |s|      
            print(s)
          end     
          return lines

        rescue SystemCallError => e
              raise e, 'ptt_login() system call:' + e.to_s()
          rescue TimeoutError => e
              raise e, 'ptt_login() timeout:' + e.to_s()
          rescue SocketError => e        
              raise e, 'ptt_login() socket:' + e.to_s()    
          rescue Exception => e
              raise e, 'ptt_login() unknown:' + e.to_s()      
        end    
      end

      def search_by_promote(tn, num)
        raise ArgumentError, 'search_by_title() invalid telnet reference:' unless tn.kind_of? Net::Telnet
        raise ArgumentError, 'search_by_title() invalid title:' unless title.kind_of? String
        begin
          tn.print('Z')
          tn.waitfor(/\xAA\xBA\xA4\xE5\xB3\xB9:\s*#{AnsiCursorHome}#{AnsiSetDisplayAttr}\s+#{AnsiSetDisplayAttr}#{AnsiEraseEOL}#{AnsiCursorHome}\Z/n){ |s| print(s) }
          result = tn.cmd( 'String' => '-5', 'Match' => /#{ArticleList}/n){ |s| print(s) }

          return result     
        rescue SystemCallError => e
            raise e, 'ptt_login() system call:' + e.to_s()
        rescue TimeoutError => e
            raise e, 'ptt_login() timeout:' + e.to_s()
        rescue SocketError => e        
            raise e, 'ptt_login() socket:' + e.to_s()    
        rescue Exception => e
            raise e, 'ptt_login() unknown:' + e.to_s()      
        end 
      end

      def search_by_title(tn, title)
        raise ArgumentError, 'search_by_title() invalid telnet reference:' unless tn.kind_of? Net::Telnet
        raise ArgumentError, 'search_by_title() invalid title:' unless title.kind_of? String
        begin
          tn.print('?')
          tn.waitfor(/\xB7\x6A\xB4\x4D\xBC\xD0\xC3\x44:\s*#{AnsiCursorHome}#{AnsiSetDisplayAttr}\s+#{AnsiSetDisplayAttr}#{AnsiEraseEOL}#{AnsiCursorHome}\Z/n){ |s| print(s) }
          result = tn.cmd( 'String' => nil, 'Match' => /#{ArticleList}/){ |s| print(s) }
          return result     
        rescue SystemCallError => e
            raise e, 'ptt_login() system call:' + e.to_s()
        rescue TimeoutError => e
            raise e, 'ptt_login() timeout:' + e.to_s()
        rescue SocketError => e        
            raise e, 'ptt_login() socket:' + e.to_s()    
        rescue Exception => e
            raise e, 'ptt_login() unknown:' + e.to_s()      
        end 
      end


      def gsub_ansi_by_space(s)
        raise ArgumentError, 'search_by_title() invalid title:' unless s.kind_of? String
        s.gsub!(/\x1B\[(?:(?>(?>(?>\d+;)*\d+)?)m|(?>(?>\d+;\d+)?)H|K)/) do |m|
          if m[m.size-1].chr == 'K'
            '\n'
          else
            ' '
          end
        end
      end 



      def get_article_author_list(s)
        raise ArgumentError, 'get_article_author_list() invalid title:' unless s.kind_of? String
        list = []
        s.scan(/\s(\d+)(?>\s+)(?>(?:[~+mMsS!](?=\s))?)(?>(?>\s*(?>\xC3\x7A|XX|X\d|\d+)(?=\s))?)(?>(?>\s*(?>\d+\/)?\d+(?=\s))?)(?>\s*)(?!(?>\d+\s))(\w{2,})\s+/xn){    
          |num, author| list.push([num, author]) # save article number & author
        }
        return list
      end


      def goto_by_article_num(tn, num)
        raise ArgumentError, 'goto_by_article_num() invalid telnet reference:' unless tn.kind_of? Net::Telnet 
        raise ArgumentError, 'goto_by_article_num() invalid num:' unless num.kind_of? Integer or num.kind_of? String
        tn.cmd('String' => (num.kind_of?(Integer) ? num.to_s : num), 'Match' => /#{AnsiEraseEOL}#{AnsiCursorHome}\Z/){ |s| print(s) }
        
      end

      # send to mail
      def email_article(tn, email_box=nil)
        raise ArgumentError, 'email_article() invalid telnet reference:' unless tn.kind_of? Net::Telnet
        if email_box != nil && ( !(email_box.kind_of? String) || !(/^#{EmailBox}$/ =~ email_box) )
          raise ArgumentError, 'email_article() invalid email_box:'
        end
        begin
          tn.print('F')
          # ...[xxx@yyy.zzz] (Y/N/Q)？
          ptt_output = tn.waitfor(/\[#{EmailBox}\]\s+\xB6\xDC\(Y\/N\/Q\)\xA1\x48\[Y\]\s*#{AnsiSetDisplayAttr}\s+#{AnsiSetDisplayAttr}\x08+\Z/){ |s| print(s) }
          email_box_current = ptt_output[/\b#{EmailBox}\b/]
          if email_box == nil || email_box == email_box_current     
            result = tn.cmd('String' => '', 'Match' => /(?>#{PressAnyKeyToContinue2}|#{ArticleList})\Z/){ |s| print(s) }
            if not (/#{PressAnyKeyToContinue2}\Z/ =~ result)
              return true # success
            end
            tn.cmd('String' => '', 'Match' => /#{ArticleList}\Z/) do |s|
              print(s)
            end
            return false # failed
          end
          
          tn.cmd('String' => 'n', 
               'Match' => /\xC2\xE0\xB1\x48\xA6\x61\xA7\x7D\xA1\x47
                          #{AnsiSetDisplayAttr}
                          \s+
                          #{AnsiCursorHome}n
                          #{AnsiSetDisplayAttr}
                          #{AnsiCursorHome}\Z/x
                ){ |s| print(s) }

          # xxx@yyy.zzz           
          result = tn.cmd('String' => email_box,
                    'Match' => /(?>#{PressAnyKeyToContinue2}|#{ArticleList})\Z/
                     ){ |s| print(s) }

          if not (/#{PressAnyKeyToContinue2}\Z/ =~ result)
            return true # success!
          end
          
          tn.cmd('String' => '', 'Match' => /#{ArticleList}\Z/) do |s|
            print(s)
          end                           
          return false # failed!
        rescue SystemCallError => e
            raise e, 'email_article() system call:' + e.to_s()
        rescue TimeoutError => e
            raise e, 'email_article() timeout:' + e.to_s()
        rescue SocketError => e        
            raise e, 'email_article() socket:' + e.to_s()    
        rescue Exception => e
            raise e, 'email_article() unknown:' + e.to_s()      
        end     
      end

      # ===================
    end
  end
end
