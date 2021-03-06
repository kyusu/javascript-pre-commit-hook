#################################################################################
# Inspired by the PHP Syntax Check for Git pre-commit hook for Windows PowerShell
# which was written by Vojtech Kusy <wojtha@gmail.com>
# See https://gist.github.com/wojtha/1034262
#################################################################################

function js_syntax_check {
    
	$err_counter = 0;
		
	write-host "Pre-commit JS, JSON & SCSS syntax check:" -foregroundcolor "white"
	git diff-index --name-only --cached HEAD --diff-filter=ACM -- | foreach {
		if ($_ -match ".*\.(js)$") {
			$file = $matches[0];
			$errors = & eslint $file
			if ($errors) {
				write-host $file ":" $errors -foregroundcolor "red"
				$err_counter++
			} else {				
                write-host $file ": OK" -foregroundcolor "green"	
			}
		}
        if ($_ -match ".*\.(json)$") {
			$file = $matches[0];
            $errors = & jsonlint -qc $file 2>&1
			if ($errors) {			
                write-host $file ":" $errors -foregroundcolor "red";	
                $err_counter++;
            } else {			
                write-host $file ": OK" -foregroundcolor "green"               		
            }
		}
        if ($_ -match ".*\.(scss)$") {
			$file = $matches[0];
            $errors = & scss-lint $file 2>&1
			if ($errors) {			
                write-host $file ":" $errors -foregroundcolor "red";	
                $err_counter++;
            } else {			
                write-host $file ": OK" -foregroundcolor "green"               		
            }
		}
	}
	if ($err_counter -gt 0) {
	   exit 1
	}    
}

### MAIN ###

js_syntax_check
