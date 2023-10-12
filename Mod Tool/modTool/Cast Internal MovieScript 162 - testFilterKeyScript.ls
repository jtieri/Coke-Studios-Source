on testFilterKey sourceMember, targetMember
  repeat with s = 1 to sourceMember.text.char.count
    if (targetMember.text contains sourceMember.text.char[s]) = 0 then
      alert("Source char:" && sourceMember.text.char[s] && "is not included in target.")
    end if
  end repeat
  put "Done!"
end
