on getregpoints
  myList = ["h_wlk_lg_13_", ["7_3", "7_2", "7_1", "7_0", "3_3", "3_2", "3_1", "3_0", "2_3", "2_2", "2_1", "2_0", "1_3", "1_2", "1_0", "0_3", "0_2", "0_1", "0_0"]]
  missed = []
  done = []
  repeat with n = 1 to count(myList[2])
    comparenum = 1
    myMember = member(string(myList[1] & myList[2][n]))
    test = 1
    repeat while test = 1
      if comparenum < 10 then
        stringnum = "0" & comparenum
      else
        stringnum = string(comparenum)
      end if
      comparemember = member(myList[1].char[1..length(myList[1]) - 3] & stringnum & "_" & myList[2][n])
      if voidp(comparemember) or (comparemember.memberNum < 1) then
        comparenum = comparenum + 1
        if comparenum = integer(myList[1].char[11..12]) then
          append(missed, myMember.name)
          test = 0
        else
          next repeat
        end if
      end if
      if comparemember.rect <> myMember.rect then
        comparenum = comparenum + 1
        if comparenum = integer(myList[1].char[11..12]) then
          append(missed, myMember.name)
          test = 0
        end if
        next repeat
      end if
      myMember.regPoint = comparemember.regPoint
      append(done, myMember.name)
      test = 0
    end repeat
  end repeat
  put "missed = " & missed
  put "done = " & done
end
