Automating AWS with Terraform
We are using git branches to track changes

```bash
gcm  # git checkout $(git_main_branch)
ggpull  # git pull origin "$(git_current_branch)"
# loop from here
gcb feat/test-gh  # git checkout -b feat/test-gh
touch test-gh-cli
gaa  # git add --all
gcz  # git cz -sS
ggpush  # git push origin "$(git_current_branch)"
ghprcr  # gh pr create --title "$(git log --pretty=format:%s -1)" --body ""
ghprmerge  # gh pr merge --squash --body "" "$(gh pr list --state open --json number|jq -r '.[].number')"

# start again
gcm
ggpull
# from top
# gcb...
```
