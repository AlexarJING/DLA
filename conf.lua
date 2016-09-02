io.stdout:setvbuf("no")
function love.conf(t)
    t.identity = "DLA"        
    t.version = "0.10.1"                           
    t.window.title = "DLA"         
    t.window.width = 800               
    t.window.height = 800 
    t.window.vsync = false  
end