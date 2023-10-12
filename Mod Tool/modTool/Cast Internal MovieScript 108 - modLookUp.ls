global oDenizenManager, sModScreenName

on modLookUp sScreenName
  sEnv = oDenizenManager.getEnvironment()
  case sEnv of
    "DEV", "DEV2":
      case sScreenName of
        "Quincy":
          sModName_Initials = "es"
        "Paul", "Paul_Dev":
          sModName_Initials = "pe"
        "fuzzy_lollipop", "RodTheMod":
          sModName_Initials = "mb"
        "dev4":
          sModName_Initials = "go"
        "Darren":
          sModName_Initials = "ds"
        "ASLAN":
          sModName_Initials = "aq"
        "miechus":
          sModName_Initials = "mm"
        otherwise:
          sModName_Initials = sScreenName
      end case
    "TEST":
      case sScreenName of
        "frankie_mouse", "Paul":
          sModName_Initials = "pe"
        "fuzzy_lollipop", "Fidel":
          sModName_Initials = "mb"
        "Jorge", "studiocom-atl":
          sModName_Initials = "go"
        "ASLAN":
          sModName_Initials = "aq"
        "miechus":
          sModName_Initials = "mm"
        otherwise:
          sModName_Initials = sScreenName
      end case
    "PROD":
      case sScreenName of
        "Jym", "frankiemouse":
          sModName_Initials = "pe"
        "creepy_B":
          sModName_Initials = "mb"
        "Jorge":
          sModName_Initials = "go"
        "ASLAN":
          sModName_Initials = "aq"
        "Quincy", "csethan":
          sModName_Initials = "es"
        "blastmaestro":
          sModName_Initials = "mg"
        "Darren", "TheDude_Abides":
          sModName_Initials = "ds"
        "Penultimatum":
          sModName_Initials = "mp"
        "AndreaAC":
          sModName_Initials = "acl"
        "gte856i":
          sModName_Initials = "sb"
        "robeggers":
          sModName_Initials = "sr"
        "asacarr":
          sModName_Initials = "acr"
        "djfoo_sonz":
          sModName_Initials = "rf"
        "cs_tim":
          sModName_Initials = "th"
        "BenjyMouse":
          sModName_Initials = "rt"
        otherwise:
          sModName_Initials = sScreenName
      end case
    otherwise:
      sModName_Initials = sScreenName
  end case
  return sModName_Initials
end
