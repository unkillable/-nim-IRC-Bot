import sockets
import strutils
proc Iris() = 
    var s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP, buffered = true)
    var name = "Iris"
    var channel:string = "#mootsinsuits"
    connect(s, "irc.tm", Port(6667), AF_INET)
    send(s, "NICK Iris\r\n")
    send(s, "USER Iris Iris Iris :Iris\r\n")
    var buffer = TaintedString""
    while true:
        readLine(s, buffer)
        echo(buffer)
        if " 396 " in buffer:
             var join = "JOIN $#\r\n" % [channel]
             echo join
             send(s, join)
        if buffer.startswith("PING "):
             echo "Recivied PING. Sending PONG..."
             var hashbit:string = strip(split(buffer, " ")[1], true, true)
             var ping = "PONG $#\r\n" % [hashbit]
             echo ping
             send(s, ping)
        if "PRIVMSG" in buffer:
             channel = strip(split(buffer, " PRIVMSG ")[1], true, true)
             channel = strip(split(channel, " :")[0], true, true)
             echo channel
             var data:string = strip(split(buffer, "PRIVMSG $# :" % [channel])[1], true, true)
             echo data
             if data.startswith(".j "):
                  var chan:string = strip(split(buffer, ".j ")[1], true, true)
                  var join = "JOIN $#\r\n" % [chan]
                  send(s, join)
             if data.startswith(".p "):
                  var chan:string = strip(split(buffer, ".p ")[1], true, true)
                  var part = "PART $#\r\n" % [chan]
                  send(s, part)    
             if data.startswith(".q"):
                  send(s, "QUIT\r\n")   
             if data.startswith(".nim"):
                  send(s, "PRIVMSG $# :I am a bot made in nim\r\n" % [channel])
    echo("Looks like I died")
Iris()
