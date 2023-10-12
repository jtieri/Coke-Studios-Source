property pParentWindow
global oDenizenManager

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on getIJbackbutton me
  return me.spriteNum
end

on mouseUp me
  mylevel = pParentWindow.pScrollingLists.cataloglist.pCatalogLevel
  case mylevel of
    #songs:
      pParentWindow.pScrollingLists.cataloglist.pSelectedSong = VOID
      sendAllSprites(#disableaddsong)
      sendAllSprites(#disabledownloadsong)
      pParentWindow.pScrollingLists.cataloglist.pCatalogLevel = #Artists
      pParentWindow.pScrollingLists.cataloglist.displayloading()
      if the runMode = "author" then
        pParentWindow.pScrollingLists.cataloglist.updatecontent()
      else
        oDenizenManager.getArtistsByGenre(pParentWindow.pScrollingLists.cataloglist.pSelectedgenre)
      end if
    #Artists:
      pParentWindow.pScrollingLists.cataloglist.pCatalogLevel = #Genres
      pParentWindow.pScrollingLists.cataloglist.displayloading()
      if the runMode = "author" then
        pParentWindow.pScrollingLists.cataloglist.updatecontent()
      else
        oDenizenManager.getGenres()
      end if
  end case
end
