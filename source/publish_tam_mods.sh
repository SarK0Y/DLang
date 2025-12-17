#!/usr/bin/env fish
set prev_dir (pwd)
echo $prev_dir
cd ~/Dlang/TAM_mods/github/
rm -rf ~/Dlang/TAM_mods/github/source/*
echo (pwd)
cp -f ../source/* ./source
cp -f ../dub.sdl ./
git add dub.sdl source
set m  "-m"
set count 1
set indx 0;
while test "$argv[$count]" = "-m" 
	if test $count = 1
            set indx (math "$count + 1")
            set m "$m \"$argv[$indx]\""
            echo $count
	else
            set indx (math "$count + 1")
            set m "$m -m \"$argv[$indx]\""
            echo $count
	end
	echo $m
	set count (math "$count + 2")
end
#set final_m (string replace -r '^\"|\"$' '' $m)
set git_commit "git commit $m"
echo $git_commit
eval $git_commit
git push -u
cd $prev_dir
