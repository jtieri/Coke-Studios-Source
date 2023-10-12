property pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  timeoutobject = timeout("capdecibels").new(7000, #update, me)
  return me
end

on update me
  me.cancelCapTimer()
  pParentWindow.closeWindow()
end

on cancelCapTimer me
  timeout("capdecibels").forget()
end
