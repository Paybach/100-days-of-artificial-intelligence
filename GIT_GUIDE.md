# Beginner Git Guide

Git records changes on your computer. GitHub stores a copy online. A `commit`
is a saved checkpoint. A `push` uploads your local commits to GitHub.

## Publish Your Daily Work

Run these commands from PowerShell after finishing a day's work:

```powershell
cd "C:\Users\noaha\OneDrive\Documents\New project\100-days-of-artificial-intelligence"
git status
git add .
git commit -m "Complete Day 001: AI map and goals"
git push
```

Change the commit message each day so it describes your work.

## Before Starting a New Day

Pull any changes from GitHub before editing:

```powershell
cd "C:\Users\noaha\OneDrive\Documents\New project\100-days-of-artificial-intelligence"
git pull --ff-only
```

## Useful Checks

```powershell
git status
git log --oneline -5
```

`git status` shows changed files. `git log --oneline -5` shows your five most
recent checkpoints.

## If Git Says There Is Nothing to Commit

That usually means no files changed, or you forgot to save your edits. Run:

```powershell
git status
```

## If a Push Is Rejected

Do not force-push while learning. Bring down the latest online commits first:

```powershell
git pull --rebase
git push
```

If Git reports a conflict, stop and review the conflicting files before
continuing.
