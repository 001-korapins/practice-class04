# INT142 Software Development Tools
## Class 04 Resolve Conflicts in VCS

### Overview

In this class, you will create a new branch `class04` and work on this branch instead of `main`. `index.html` will be pulled from `IT-BANGMOD-INT142-2025/class02-<your-github-id>` repository. GitHub Action is used to create a new commit on remote repository to simulate having a collaborator pushing a new commit ahead of your local commit. You need to resolve conflicts correctly before you can push your work to remote repository.  

---

### Stage 1 - Create `class04` branch and add `index.html` from `class02` to `class04` repository
### Instructions

1. Clone `class04-<your-github-id>` repository to `Documents/<your-github-id>/class04`

2. Configure author's name and author's email to `<Firstname Surname> (INT142-class04)` and `<your-private-github-email>`, respectively

3. Create a new branch `class04`

4. Switch to `class04` branch.

5. Pull files from `IT-BANGMOD-INT142-2025/class02-<your-github-id>` without making a commit and commit histories
    ```bash
    remote: Enumerating objects: 17, done.
    remote: Counting objects: 100% (8/8), done.
    remote: Compressing objects: 100% (4/4), done.
    remote: Total 17 (delta 4), reused 6 (delta 4), pack-reused 9 (from 1)
    Unpacking objects: 100% (17/17), 7.47 KiB | 103.00 KiB/s, done.
    From https://github.com/IT-BANGMOD-INT142-2025/class02-olarnr-ad-sit
    * branch            main       -> FETCH_HEAD
    Auto-merging .github/workflows/classroom.yml
    CONFLICT (add/add): Merge conflict in .github/workflows/classroom.yml
    Auto-merging README.md
    CONFLICT (add/add): Merge conflict in README.md
    Squash commit -- not updating HEAD
    Automatic merge failed; fix conflicts and then commit the result.
    ```

6. Fix the conflict using VS Code
    - Keep `README.md` and `classroom.yml` from this repository (class04)
    - Do not modify `index.html`
    - Add both files to staging area (index)

    If you fix conflicts correctly, the output from `git status` must show as follows:
    ```bash
    $ git add .
    $ git status
    On branch class04
    Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
            new file:   index.html
    ```

7. Commit your work with the message `Add index.html from class02`. Check commit history and make sure that it is correct. If not, amend the commit meta-data.

8. Push your local commit in `class04` branch to `remotes/origin/class04`

9. Check Test 3 on GitHub, you must pass Test 3 before proceeding to Stage 2
    ```
    Test runner summary
    ┌────────────────────┬─────────────┬─────────────┐
    │ Test Runner Name   │ Test Score  │ Max Score   │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-1             │ 0           │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-2             │ 10          │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-3             │ 30          │ 30          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-4             │ 0           │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-5             │ 0           │ 30          │
    ├────────────────────┼─────────────┼─────────────┤
    │ Total:             │ 40          │ 90          │
    └────────────────────┴─────────────┴─────────────┘
    ```


---

### Stage 2 - Update `index.html` on `class04` branch
### Instructions

0. **DO NOT PULL NEW COMMIT FROM REMOTE REPOSITORY**  
    If you made a mistake, you will have to restart by deleting `class04` branch on both local and remote repository, and start again.  
    
    BE MINDFUL OF WHAT YOU ARE DOING!
    ```bash
    $ git switch main
    $ git branch -D class04        # force deletion local branch
    $ git push origin -d class04   # delete class04 on origin
    ```

1. Modify `index.html`. Replace the sentence  
`This page was created locally and pushed to GitHub Classroom.` with  
`This page was pulled from class02 repository.`.
    ```bash
    $ git diff
    diff --git a/index.html b/index.html
    index 8703068..1cde087 100644
    --- a/index.html
    +++ b/index.html
    @@ -16,7 +16,7 @@
            <h1 id="class">Class 02 Exercise 2</h1>
            <h2 id="student-name">Olarn Rojanapornpun</h2>

    -        <p>This page was created locally and pushed to GitHub Classroom.</p>
    +        <p>This page was pulled from class02 repository.</p>
        </div>

    </body>
    ```

2. Commit your change with the message `Update index.html line 19`

3. Push the new commit to remote repository.
    ```bash
     ! [rejected]        class04 -> class04 (fetch first)
    error: failed to push some refs to 'github-olarn-ad:INT142-2025-SPIKES/class04-olarnr-ad-sit.git'
    hint: Updates were rejected because the remote contains work that you do
    hint: not have locally. This is usually caused by another repository pushing
    hint: to the same ref. You may want to first integrate the remote changes
    hint: (e.g., 'git pull ...') before pushing again.
    hint: See the 'Note about fast-forwards' in 'git push --help' for details.
    ```

4. Use `git fetch` to see the commits on remote repository. Use `git status` to see the status of your local repository.

5. Use `git pull` to merge your local commit with the latest commit on remote repository.

6. Accept changes from `incoming`. Keep your name and the change you have made in step 1.

    After the fix, the `git diff` result is as follows.

    ```bash
    $ git diff index.html
    diff --cc index.html
    index 1cde087,a964190..0000000
    --- a/index.html
    +++ b/index.html
    @@@ -13,10 -13,11 +13,10 @@@

        <div class="container">
            <h1>INT142 Software Development Tools</h1>
    -         <h1 id="class">Class 02 Exercise 2</h1>
    +         <h1 id="class">Class 04</h1>
    -        <h2 id="student-name">Replace This With Your Name</h2>
    +        <h2 id="student-name">Olarn Rojanapornpun</h2>

    -        <p>This page was modified by GitHub Actions.</p>
    -
    +        <p>This page was pulled from class02 repository.</p>
        </div>

    </body>
    ```

7. Follow instructions in `git status` to complete the merge commit (with the default merge message) and push this merge commit to remote repository.

8. In the initial version of this assignment, the full score is 80 since there is a problem with Test 1 script.
    ```
    Test runner summary
    ┌────────────────────┬─────────────┬─────────────┐
    │ Test Runner Name   │ Test Score  │ Max Score   │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-1             │ 0           │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-2             │ 10          │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-3             │ 30          │ 30          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-4             │ 10          │ 10          │
    ├────────────────────┼─────────────┼─────────────┤
    │ test-5             │ 30          │ 30          │
    ├────────────────────┼─────────────┼─────────────┤
    │ Total:             │ 80          │ 90          │
    └────────────────────┴─────────────┴─────────────┘
    ```
