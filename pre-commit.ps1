###############################################################################
#
# PHP Syntax Check for Git pre-commit hook for Windows PowerShell
#
# Author: Vojtech Kusy <wojtha@gmail.com>
#
###############################################################################

### INSTRUCTIONS ###

# Place the code to file "pre-commit" (no extension) and add it to the one of 
# the following locations:
# 1) Repository hooks folder - C:\Path\To\Repository\.git\hooks
# 2) User profile template   - C:\Users\<USER>\.git\templates\hooks 
# 3) Global shared templates - C:\Program Files (x86)\Git\share\git-core\templates\hooks
# 
# The hooks from user profile or from shared templates are copied from there
# each time you create or clone new repository.

### FUNCTIONS ###

function js_syntax_check {
    
	$err_counter = 0;
		
	write-host "Pre-commit JS & JSON syntax check:" -foregroundcolor "white"
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
	}
	if ($err_counter -gt 0) {
	   exit 1
	}    
}

### MAIN ###

js_syntax_check