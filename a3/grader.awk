# grader.awk - Process student grades

# Function to calculate average
function get_avg(total, count) {
    return total / count
}

BEGIN {
    FS = ","  # Set comma as field separator
    min_score = 1000
    max_score = -1
}

NR == 1 {
    num_subjects = NF - 2  # First line: count subjects
    next
}

{
    name = $2
    total = 0

    # Add grades for this student
    for (i = 3; i <= NF; i++) {
        total += $i
    }

    average = get_avg(total, num_subjects)

    # Store information
    student_total[name] = total
    student_avg[name] = average
    student_status[name] = (average >= 70 ? "Pass" : "Fail")

    if (total > max_score) {
        max_score = total
        top_student = name
    }
    if (total < min_score) {
        min_score = total
        low_student = name
    }
}

END {
    print "Student Report:"
    print "--------------------------"
    for (name in student_total) {
        printf "Name: %-10s | Total: %3d | Average: %.2f | Status: %s\n", name, student_total[name], student_avg[name], student_status[name]
    }

    print "\nSummary:"
    print "--------------------------"
    print "Top Scoring Student: " top_student " with " max_score " points"
    print "Lowest Scoring Student: " low_student " with " min_score " points"
}

