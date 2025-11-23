#!/usr/bin/env fish
set prev_dir (pwd)
echo $prev_dir
cd ~/Dlang/TAM_mods/github/
echo (pwd)
cp -f ../source/* ./source
cp -f ../dub.sdl ./
echo (git add dub.sdl source)
set m  "-m"
set count 1
while test "$argv[$count]" = "-m" 
	set m "$m "$argv[(math "$count + 1")]
	echo $m
	set count (math "$count + 2")
end
#set final_m (string replace -r '^\"|\"$' '' $m)
set git_commit "git commit "$m
eval $git_commit
git push -u
cd $prev_dir
