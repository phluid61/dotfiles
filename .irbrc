#!ruby

IRB.conf[:SAVE_HISTORY] = 1000

IRB.conf[:PROMPT][:ANSI] = {
  :PROMPT_I => "\e[32m%N(%m)\e[0m:\e[33m%03n\e[0m:\e[35m%i\e[36m>\e[0m ",
  :PROMPT_N => "\e[32m%N(%m)\e[0m:\e[33m%03n\e[0m:\e[35m%i\e[36m>\e[0m ",
  :PROMPT_S => "\e[32m%N(%m)\e[0m:\e[33m%03n\e[0m:\e[35m%i\e[36m%l\e[0m ",
  :PROMPT_C => "\e[32m%N(%m)\e[0m:\e[33m%03n\e[0m:\e[35m%i\e[36m*\e[0m ",
  :RETURN   => "\e[90m=>\e[0m %s\n"
}
IRB.conf[:PROMPT_MODE] = :ANSI

IRB.conf[:AUTO_INDENT] = true

