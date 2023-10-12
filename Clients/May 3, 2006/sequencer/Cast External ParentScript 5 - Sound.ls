property sName, iBeats, sIcon, sAsset, sCategory, oMember

on new me, _sName, _iBeats, _sAsset, _sIcon, _sCategory, _oMember
  me.sName = _sName
  me.iBeats = _iBeats
  me.sAsset = _sAsset
  me.sIcon = _sIcon
  me.sCategory = _sCategory
  me.oMember = _oMember
  return me
end

on getName me
  return me.sName
end

on getBeats me
  return me.iBeats
end

on getIcon me
  return me.sIcon
end

on getAsset me
  return me.sAsset
end

on getCategory me
  return me.sCategory
end

on getMember me
  return me.oMember
end
