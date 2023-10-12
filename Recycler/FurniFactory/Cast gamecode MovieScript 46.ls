on stopMovie
  if the runMode contains "Author" then
    mynetid = preloadNetThing("./Empty.cst")
    repeat while not netDone(mynetid)
      nothing()
    end repeat
    castLib("people").fileName = "./Empty.cst"
  end if
end
