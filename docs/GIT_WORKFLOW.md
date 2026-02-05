# Git Workflow Guide

This document outlines the Git workflow for the HR Attendance project.

---

## Branch Naming Convention

Use the following prefixes for branch names:

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New features | `feature/clock-in-button` |
| `bugfix/` | Bug fixes | `bugfix/attendance-crash` |
| `hotfix/` | Urgent production fixes | `hotfix/login-error` |
| `refactor/` | Code refactoring | `refactor/attendance-controller` |
| `docs/` | Documentation changes | `docs/api-endpoints` |
| `test/` | Adding or updating tests | `test/attendance-usecase` |

---

## Basic Git Commands

### 1. Check Current Status

```bash
# View current branch and file changes
git status

# View which branch you're on
git branch
```

### 2. Create a New Branch

```bash
# Create and switch to a new branch
git checkout -b feature/your-feature-name

# Or using newer syntax
git switch -c feature/your-feature-name
```

### 3. Stage Changes

```bash
# Stage specific files
git add lib/features/attendance/presentation/screens/clock_in_screen.dart

# Stage all changes in a directory
git add lib/features/attendance/

# Stage all changes
git add .

# Stage changes interactively (review each change)
git add -p
```

### 4. Commit Changes

```bash
# Commit with a message
git commit -m "Add clock-in button to attendance screen"

# Commit with multi-line message
git commit -m "Add clock-in functionality

- Add ClockInButton widget
- Connect to AttendanceController
- Handle loading and error states"
```

### 5. Push Changes

```bash
# Push to remote (first time for a branch)
git push -u origin feature/your-feature-name

# Subsequent pushes
git push
```

### 6. Pull Latest Changes

```bash
# Pull changes from remote
git pull

# Pull with rebase (cleaner history)
git pull --rebase
```

---

## Commit Message Guidelines

### Format

```
<type>: <short description>

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Code style (formatting, semicolons) |
| `refactor` | Code refactoring |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks |

### Examples

```bash
# Feature
git commit -m "feat: add clock-in functionality"

# Bug fix
git commit -m "fix: resolve attendance history loading issue"

# Refactoring
git commit -m "refactor: simplify attendance controller logic"

# Documentation
git commit -m "docs: update API endpoint documentation"

# With body for complex changes
git commit -m "feat: implement attendance history pagination

- Add pagination parameters to GetAttendanceHistoryUsecase
- Update AttendanceController to handle page loading
- Add load more button to history screen"
```

---

## Workflow Steps

### Starting a New Feature

```bash
# 1. Make sure you're on main and up to date
git checkout main
git pull

# 2. Create a new feature branch
git checkout -b feature/clock-out-reminder

# 3. Make your changes
# ... edit files ...

# 4. Stage and commit regularly
git add .
git commit -m "feat: add reminder notification service"

# 5. Push to remote
git push -u origin feature/clock-out-reminder
```

### Fixing a Bug

```bash
# 1. Create a bugfix branch from main
git checkout main
git pull
git checkout -b bugfix/attendance-date-format

# 2. Fix the bug and commit
git add .
git commit -m "fix: correct date format in attendance history"

# 3. Push and create a pull request
git push -u origin bugfix/attendance-date-format
```

### Keeping Your Branch Updated

```bash
# Option 1: Merge main into your branch
git checkout feature/your-feature
git merge main

# Option 2: Rebase onto main (cleaner history)
git checkout feature/your-feature
git rebase main
```

---

## Working with Pull Requests

### Creating a Pull Request

1. Push your branch to remote:
   ```bash
   git push -u origin feature/your-feature
   ```

2. Go to GitHub/GitLab and create a Pull Request

3. Fill in the PR template:
   - **Title**: Brief description of changes
   - **Description**: What changed and why
   - **Testing**: How to test the changes

### Reviewing Pull Requests

1. Check out the PR branch locally:
   ```bash
   git fetch origin
   git checkout feature/branch-to-review
   ```

2. Run the app and test the changes:
   ```bash
   flutter run
   ```

3. Run tests:
   ```bash
   flutter test
   ```

### After PR is Merged

```bash
# Switch back to main
git checkout main

# Pull the merged changes
git pull

# Delete your local branch
git branch -d feature/your-feature

# Delete remote branch (if not auto-deleted)
git push origin --delete feature/your-feature
```

---

## Handling Conflicts

### When Conflicts Occur

```bash
# 1. Pull/merge and see conflicts
git pull
# or
git merge main

# 2. Open conflicting files and resolve
# Look for conflict markers:
# <<<<<<< HEAD
# your changes
# =======
# incoming changes
# >>>>>>> main

# 3. After resolving, stage the files
git add .

# 4. Complete the merge
git commit -m "Merge main into feature/your-feature"
```

### Using VS Code for Conflicts

1. Open the conflicting file
2. Use the inline buttons: "Accept Current", "Accept Incoming", or "Accept Both"
3. Save the file
4. Stage and commit

---

## Useful Git Commands

### View History

```bash
# View commit history
git log

# View compact history
git log --oneline

# View history with graph
git log --oneline --graph --all

# View changes in a commit
git show <commit-hash>
```

### Undo Changes

```bash
# Discard changes in working directory
git checkout -- <file>
# or
git restore <file>

# Unstage a file
git reset HEAD <file>
# or
git restore --staged <file>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes) - CAUTION!
git reset --hard HEAD~1
```

### Stash Changes

```bash
# Stash current changes
git stash

# Stash with a message
git stash save "WIP: clock-in feature"

# List stashes
git stash list

# Apply most recent stash
git stash pop

# Apply specific stash
git stash apply stash@{1}

# Delete a stash
git stash drop stash@{0}
```

### View Differences

```bash
# View unstaged changes
git diff

# View staged changes
git diff --staged

# View changes between branches
git diff main..feature/your-feature
```

---

## Best Practices

1. **Commit Often**: Make small, focused commits
2. **Write Clear Messages**: Describe what and why, not how
3. **Pull Before Push**: Always pull latest changes before pushing
4. **Don't Commit Secrets**: Never commit API keys, passwords, or `.env` files
5. **Review Before Committing**: Use `git diff` to review changes
6. **Keep Branches Short-Lived**: Merge features promptly to avoid conflicts
7. **Use .gitignore**: Ensure build files and dependencies are ignored

---

## Project .gitignore

Ensure these are in your `.gitignore`:

```
# Flutter/Dart
.dart_tool/
.packages
build/
*.iml

# IDE
.idea/
.vscode/
*.swp

# macOS
.DS_Store

# Environment
.env
.env.local

# Generated files
*.g.dart
*.freezed.dart
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Create branch | `git checkout -b branch-name` |
| Switch branch | `git checkout branch-name` |
| Stage all | `git add .` |
| Commit | `git commit -m "message"` |
| Push | `git push` |
| Pull | `git pull` |
| View status | `git status` |
| View history | `git log --oneline` |
| Stash changes | `git stash` |
| Apply stash | `git stash pop` |
| Delete branch | `git branch -d branch-name` |

---

## Questions?

If you have questions about Git workflow, refer to:
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
