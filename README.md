### Prospector RL ###

---

#### [Ideas](https://github.com/SoPissd/Prospector-RL/compare/changes) for [Prospector](http://prospector.at/forum/), a roguelike written by Magellan. ####


[Prospector](http://prospector.at/forum/) is one of my favorite roguelikes. So when its [sources](https://code.google.com/p/rlprospector/source/list) met up with some of my free time I picked up [FreeBASIC](http://www.freebasic.net/), got a [Debugger](http://freebasic.net/forum/viewtopic.php?f=8&t=13935), the [Sound Library](http://freebasic.net/forum/viewtopic.php?t=17740) and of course an [IDE](http://sourceforge.net/projects/fbedit/).


I spent a lot of time on the [wiki](http://www.freebasic.net/wiki/wikka.php?wakka=FBWiki), slugging my way through the [functional](http://www.freebasic.net/wiki/wikka.php?wakka=CatPgFunctIndex), and sometimes the [topical](http://www.freebasic.net/wiki/wikka.php?wakka=CatPgProgrammer) index as well to get up to speed with the language.

I learned about the [png library](http://freebasic.net/forum/viewtopic.php?t=8024), saw that the language has a solid set of [OOP](http://www.freebasic.net/wiki/wikka.php?wakka=TutBeginnersGuideToTypesAsObjects) [primitives](http://www.freebasic.net/wiki/wikka.php?wakka=TutBeginnersGuideToTypesAsObjects2) and even features [RTTI](http://freebasic.net/forum/viewtopic.php?f=9&t=19255). There was an [MLD](http://www.freebasic.net/forum/viewtopic.php?f=7&t=3545&p=27738),  [LUA](http://freebasic.net/forum/viewtopic.php?p=94556) examples, [Cons drivers](www.freebasic.net/forum/viewtopic.php?f=3&t=22272&p=195412), [GDI discussions](http://www.freebasic.net/forum/search.php?keywords=GDI) and an impressive [ext-lib](http://ext.freebasic.net/dev-docs/) available for it. 

Having [mostly read](http://stackoverflow.com/questions/tagged/git) the [Git book](http://git-scm.com/book), and [free from](http://longair.net/blog/2012/05/07/the-most-confusing-git-terminology/) [svn](https://subversion.apache.org/packages.html), I practiced my [cli-fu](http://git-scm.com/docs), brushed up on [markdown](http://sourceforge.net/p/npp-plugins/wiki/markdown_syntax/), hooked up [some tools](http://stackoverflow.com/questions/1881594/use-winmerge-inside-of-git-to-file-diff) etc etc etc.

A few helpful scripts emerged
```
svn.bat:  @D:\dev\Apache-Subversion-1.8.8\bin\svn %1 %2 %3 %4 %5 %6 %7 %8 %9
```
```
git.bat:  @C:\WINDOWS\system32\cmd.exe /c ""D:\dev\Git\bin\sh.exe" --login -i"
```
```
fbc.bat:  @..\..\fb\FreeBASIC-0.90.1-win32\fbc %1 %2 %3 %4 %5 %6 %7 %8 %9
```

even settings for git
```
[merge]
    tool = winmerge
[mergetool "winmerge"]
	cmd = git.winmerge.sh "$PWD/$LOCAL" "$PWD/$MERGED" 
	trustExitCode = false
	keepBackup = false 	
[diff]
	tool = winmerge
[difftool "winmerge"]
	cmd = git.winmerge.sh "$PWD/$LOCAL" "$PWD/$MERGED" 
[difftool]
	prompt = false
[core]
	editor = git.npp.sh
```
```
[merge]
	conflictstyle = merge
```

and two simple shell scripts
```
#!/bin/sh
D:/Portable/WinMerge/WinMergeU.exe "$1" "$2" 
```
```
#!/bin/sh
D:/Portable/NPP/notepad++.exe -multiInst -nosession -noPlugin $*
```


But that's all a lie. Everyone's of course born with all this in their fingers and on their disks. 

I just wrote it up so that you can perhaps share in the fantasy.

You found it interresting?  Too bad. I don't even know if I'm still here.  Plus, I don't expect contributions from anyone. Its really not my baby, I just wanted to fix a few things so that I could play.  

Meanwhile, merging elsewhere and not liking it, expect this fork to get blown away if and as I rewrite its history to integrate Magellan's new [svn releases](https://code.google.com/p/rlprospector/source/list).

[Browse my changes](https://github.com/SoPissd/Prospector-RL/compare/changes) to see how this code differs from mainline. That's the point of this repo. **Enjoy!**

