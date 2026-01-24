#!/bin/sh

# Define regex patterns
AUTHOR_REGEX="^[A-Za-z]+[[:space:]]+[A-Za-z]+[[:space:]]*\(INT142-class04\)$"
EMAIL_REGEX="@users.noreply.github.com$"

test1() {
    printf "\n---------------------------------------------------\n"
    echo "Test 1: Expect Main branch to be unchanged (10 Points)"
    
    # Get template or parent repo URL
    TEMPLATE_URL=$(gh repo view --json templateRepository,parent -q '{{if .templateRepository}}{{.templateRepository.url}}{{else if .parent}}{{.parent.url}}{{end}}' 2>/dev/null || echo "")
    if [ -z "$TEMPLATE_URL" ]; then
        echo "⚠️ Unable to determine template or parent repository."
        echo "  Skipping test."
        return 0
    fi

    git remote add template "$TEMPLATE_URL" 2>/dev/null || git remote set-url template "$TEMPLATE_URL"
    git fetch template main > /dev/null 2>&1 || {
        echo "⚠️ Unable to fetch main branch from template/parent repository."
        echo "  Skipping test."
        return 0
    }

    NON_BOT_COMMITS=$(git log template/main..HEAD --format='%an' | grep -v "github-classroom\[bot\]" | grep -v "GitHub Classroom")

    if [ -n "$NON_BOT_COMMITS" ]; then
        echo "❌ Main branch modification detected!"
        echo "   The following unauthorized authors pushed to main:"
        echo "$NON_BOT_COMMITS"
        return 1
    else
        echo "✅ Main branch is valid."
    fi

    TOTAL_SCORE=$(( TOTAL_SCORE + 10))
}


test2 () {
    printf "\n---------------------------------------------------\n"
    echo "Test 2: Branch Existence (10 Points) -- Stage 1 Step 3"
    
    if git show-ref --quiet refs/remotes/origin/class04; then
        echo "✅ Branch class04 found."
    else
        echo "❌ Branch class04 not found on remote."
        return 1
    fi
    
    TOTAL_SCORE=$((TOTAL_SCORE + 10))
}


test3 () {
    printf "\n---------------------------------------------------\n"
    echo "Test 3: Commit 'Add index.html from class02' (30 Points) -- Stage 1 Step 7"
    
    COMMIT=$(git log origin/class04 --grep="Add index.html from class02" --format=%H -n 1)
    if [ -z "$COMMIT" ]; then 
        echo "❌ Commit not found"
        return 1
    fi

    AUTHOR=$(git show -s --format='%an' $COMMIT)
    EMAIL=$(git show -s --format='%ae' $COMMIT)
    CONTENT=$(git show $COMMIT:index.html || echo "")

    # Check H1 content
    if ! (printf "%s" "$CONTENT" | grep -q "<h1>INT142 Software Development Tools</h1>"); then 
        echo "❌ Missing H1 tag"
        return 1
    fi

    # Check Author/Email
    if ! (echo "$AUTHOR" | grep -qE "$AUTHOR_REGEX"); then 
        echo "❌ Wrong Author: $AUTHOR"
        return 1
    fi
    if ! (echo "$EMAIL" | grep -qE "$EMAIL_REGEX"); then 
        echo "❌ Wrong Email: $EMAIL"
        return 1
    fi

    # Compare files to Main
    HASH_RM_MAIN=$(git rev-parse origin/main:README.md)
    HASH_RM_CURR=$(git rev-parse $COMMIT:README.md)
    if [ "$HASH_RM_MAIN" != "$HASH_RM_CURR" ]; then 
        echo "❌ README modified"
        return 1
    fi

    HASH_CLASSROOM_MAIN=$(git rev-parse origin/main:.github/workflows/classroom.yml 2>/dev/null || echo "")
    HASH_CLASSROOM_CURR=$(git rev-parse $COMMIT:.github/workflows/classroom.yml 2>/dev/null || echo "")
    if [ "$HASH_CLASSROOM_MAIN" != "$HASH_CLASSROOM_CURR" ]; then 
        echo "❌ classroom.yml modified"
        return 1
    fi

    if ! (printf "%s" "$CONTENT" | grep -q "<title>Class 02 Exercise 2</title>"); then 
        echo "❌ Missing '<title>Class 02 Exercise 2</title>'"
        return 1
    fi
    if ! (printf "%s" "$CONTENT" | grep -q "<h1 id=\"class\">Class 02 Exercise 2</h1>"); then 
        echo "❌ Missing '<h1 id=\"class\">Class 02 Exercise 2</h1>'"
        return 1
    fi
    
    echo "✅ Test 3 Passed"
    TOTAL_SCORE=$((TOTAL_SCORE + 30))

    # If there is no commit "Update index.html to class04 by GitHub Actions" after this commit, replace index.html with .github/src/index.html and make a commit
    COMMIT=$(git log origin/class04 --grep="Update index.html to class04 by GitHub Actions" --format=%H -n 1)
    if [ -z "$COMMIT" ]; then 
        printf "\nCheck on GitHub that new commit 'Update index.html to class04 by GitHub Actions' is created.\n"
    fi
}


test4 () {
    printf "\n---------------------------------------------------\n"
    echo "Test 4: Commit 'Update index.html line 19' (10 Points) -- Stage 2 Step 2"
    
    COMMIT=$(git log origin/class04 --grep="Update index.html line 19" --format=%H -n 1)
    if [ -z "$COMMIT" ]; then 
        echo "❌ Commit not found"
        return 1
    fi

    CONTENT=$(git show $COMMIT:index.html || echo "")
    AUTHOR=$(git show -s --format='%an' $COMMIT)
    EMAIL=$(git show -s --format='%ae' $COMMIT)

    if ! (printf "%s" "$CONTENT" | grep -q "<title>Class 02 Exercise 2</title>"); then 
        echo "❌ Missing '<title>Class 02 Exercise 2</title>'"
        return 1
    fi
    if ! (printf "%s" "$CONTENT" | grep -q "<h1 id=\"class\">Class 02 Exercise 2</h1>"); then 
        echo "❌ Missing '<h1 id=\"class\">Class 02 Exercise 2</h1>'"
        return 1
    fi
    if ! (printf "%s" "$CONTENT" | grep -q "This page was pulled from class02 repository."); then 
        echo "❌ Missing 'This page was pulled from class02 repository.'"
        return 1
    fi
    if (printf "%s" "$CONTENT" | grep -q "locally"); then 
        echo "❌ Still contains 'This page was created locally and pushed to GitHub Classroom.'"
        return 1
    fi

    if ! (echo "$AUTHOR" | grep -qE "$AUTHOR_REGEX"); then 
        echo "❌ Wrong Author: $AUTHOR"
        return 1
    fi
    if ! (echo "$EMAIL" | grep -qE "$EMAIL_REGEX"); then 
        echo "❌ Wrong Email: $EMAIL"
        return 1
    fi
        
    echo "✅ Test 4 Passed"
    TOTAL_SCORE=$((TOTAL_SCORE + 10))
}


test5 () {
    printf "\n---------------------------------------------------\n"
    echo "Test 5: Merge Commit (30 Points) -- Stage 2 Step 7"
    
    MERGE_COMMIT=$(git log origin/class04 --merges -n 1 --format=%H)
    if [ -z "$MERGE_COMMIT" ]; then 
        echo "❌ No merge commit found on class04"
        return 1
    fi

    CONTENT=$(git show $MERGE_COMMIT:index.html || echo "")
    AUTHOR=$(git show -s --format='%an' $MERGE_COMMIT)
    EMAIL=$(git show -s --format='%ae' $MERGE_COMMIT)

    if ! (printf "%s" "$CONTENT" | grep -q "<title>Class 04</title>"); then 
        echo "❌ Missing '<title>Class 04</title>'"
        return 1
    fi
    if ! (printf "%s" "$CONTENT" | grep -q "<h1 id=\"class\">Class 04</h1>"); then 
        echo "❌ Missing '<h1 id=\"class\">Class 04</h1>'"
        return 1
    fi
    if ! (printf "%s" "$CONTENT" | grep -q "This page was pulled from class02 repository."); then 
        echo "❌ Missing 'This page was pulled from class02 repository.'"
        return 1
    fi
    STUDENT_REGEX="id=\"student-name\">[[:space:]]*[A-Za-z]+[[:space:]]+[A-Za-z]+[[:space:]]*<\/h2>"
    if ! (echo "$CONTENT" | grep -qE "$STUDENT_REGEX"); then 
        echo "❌ Missing student fullname"
        return 1
    fi
    if (printf "%s" "$CONTENT" | grep -q "This page was modified by GitHub Actions."); then 
        echo "❌ Still contains 'This page was modified by GitHub Actions.' H1"
        return 1
    fi
    if (printf "%s" "$CONTENT" | grep -q "Replace This With Your Name"); then 
        echo "❌ Still contains 'Replace This With Your Name'"
        return 1
    fi
    if (printf "%s" "$CONTENT" | grep -q "locally"); then 
        echo "❌ Still contains 'This page was created locally and pushed to GitHub Classroom.'"
        return 1
    fi
    if ! (echo "$AUTHOR" | grep -qE "$AUTHOR_REGEX"); then 
        echo "❌ Wrong Author: $AUTHOR"
        return 1
    fi
    if ! (echo "$EMAIL" | grep -qE "$EMAIL_REGEX"); then 
        echo "❌ Wrong Email"
        return 1
    fi

    echo "✅ Test 5 Passed"
    TOTAL_SCORE=$((TOTAL_SCORE + 30))
}

# --- Main ---
# Initialize Score
TOTAL_SCORE=0

echo "Class 04 Resolve Conflicts in VCS Tests"
test1 || (echo "Final Score: $TOTAL_SCORE" && exit 1)
test2 || (echo "Final Score: $TOTAL_SCORE" && exit 1)
test3 || (echo "Final Score: $TOTAL_SCORE" && exit 1)
test4 || (echo "Final Score: $TOTAL_SCORE" && exit 1)
test5 || (echo "Final Score: $TOTAL_SCORE" && exit 1)
printf "\n---------------------------------------------------\n"
echo "All tests passed!"
echo "Final Score: $TOTAL_SCORE"
exit 0