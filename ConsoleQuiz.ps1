#'========================================================================================
#'
#' AUTHOR: Dane Charlton
#' DATE  : 2/26/2024
#'	
#'	Overview: Script for quiz
#'	
#'	Inputs:		Text file containing fields Text.txt
#'	Breakdown:	Simple breakdown, roll through text file 
#'	
#'	Delete old log files, if present
#'	Logfile.txt and Errors.txt
#'	
#'	Add functions as necessary
#'	Assumptions:
#'	   PowerShell 3.0 is installed
#'
#'
#'========================================================================================

###########################################################
# Go ahead and just ignore any problems. What's wrong with that?
$erroractionpreference = "SilentlyContinue"
$inputFile = "Terms.txt"

###########################################################
# Variables and get current time
###########################################################
# Get start time first
$startTime = Get-Date

$testing = $True
$hash = $null
$chash = $null
$hash = @{}
$chash = @{}
$count = 0
$daLength = (get-content $inputFile).length
$num = @()
if ($testing) {
	write-host "Got Time!"
}
$questions = get-content $inputFile
$numOfQuestions = $questions.count
$goodCount = 0
###########################################################
# Delete existing reports (Diag, Output.txt)
#
If (test-path Logfile.txt){
	remove-item Logfile.txt
}
If (test-path Errors.txt){
	remove-item Errors.txt
}

###########################################################
#Starting - Load hash

ForEach ($question in $questions){
	$line = $question.trim()
	$length = $line.length
	$line = $question.split("`t")
	if ($length -gt 4){
		$term = $line[0]
		$def = $line[1]
		$hash.add($Term,$def)
	}
}

#load chash which is the key of the $hash along with a number 
ForEach ($question in $questions){
	$count = $count + 1
	$line = $question.trim()
	$length = $line.length
	$line = $question.split("`t")
	if ($length -gt 4){
		$term = $line[0]
		$def = $line[1]
		$chash.add($count,$Term)
	}
}
#create an array count
$number = 1..$daLength
$number = $number|Sort-Object {get-random}
# $num array has been randomized

$count = 1

ForEach ($num in $number){
	$realTerm = $chash[$num]
	$realAnswer = $hash[$realTerm]
	$fake1RandomNumber = 1..$daLength|get-random
	$fake2RandomNumber = 1..$daLength|get-random
	$fake3RandomNumber = 1..$daLength|get-random
	If ($fake3RandomNumber -eq $fake2RandomNumber -or $fake3RandomNumber -eq $fake1RandomNumber -or $fake1RandomNumber -eq $fake2RandomNumber -or $fake1RandomNumber -eq $num -or $fake2RandomNumber -eq $num -or $fake3RandomNumber -eq $num){
		Do {
			$fake1RandomNumber = 1..$daLength|get-random
			$fake2RandomNumber = 1..$daLength|get-random
			$fake3RandomNumber = 1..$daLength|get-random
			
		}
		While (
			$fake3RandomNumber -eq $fake2RandomNumber -or $fake3RandomNumber -eq $fake1RandomNumber -or $fake1RandomNumber -eq $fake2RandomNumber  -or $fake1RandomNumber -eq $num -or $fake2RandomNumber -eq $num -or $fake3RandomNumber -eq $num
		)
	}
	$fakeTerm1 = $chash[$fake1RandomNumber]
	$fakeTerm2 = $chash[$fake2RandomNumber]
	$fakeTerm3 = $chash[$fake3RandomNumber]
	$fakeAnswer1 = $hash[$fakeTerm1]
	$fakeAnswer2 = $hash[$fakeTerm2]
	$fakeAnswer3 = $hash[$fakeTerm3]
	$gotIt = $false
	$answersArray = @($fakeAnswer1,$fakeAnswer2,$fakeAnswer3,$realAnswer)
	
	$order = 0..3|Sort-Object {get-random}
	
	
	$first = $order[0]
	$second = $order[1]
	$third  = $order[2]
	$fourth = $order[3]
	
	$line1 = $answersArray[$first]
	$line2 = $answersArray[$second]
	$line3 = $answersArray[$third]
	$line4 = $answersArray[$fourth]
	
	Do {
		$gotIt = $false
		Write-Host "Question $Count"
		Write-Host
		Write-Host "Term is $realTerm"
		Write-Host
		Write-Host "1 $line1"
		Write-Host
		Write-Host "2 $line2"
		Write-Host
		Write-Host "3 $line3"
		Write-Host
		Write-Host "4 $line4"
		Write-Host
		$YourAnswer = Read-Host "Your Answer"
		
		Switch ($YourAnswer){
			1	{
					If ($line1 -eq $realAnswer){
						$gotIt = $true
					}
				} 
			2	{
					If ($line2 -eq $realAnswer){
						$gotIt = $true
					}

				}
			3	{
					If ($line3 -eq $realAnswer){
						$gotIt = $true
					}
				}
			4	{
					If ($line4 -eq $realAnswer){
						$gotIt = $true
					}
				}
			"Q"	{
				break
			}
			default {
				Write-Host "Select 1-4 or Q! Try again"
			}
		}
		If ($gotIt -eq $false){
			Write-Host "Missed that one!" -ForeGroundColor Red -Backgroundcolor White
		}
		else {
			Write-Host "************" -ForegroundColor Yellow
			Write-Host "Good Answer!" -ForegroundColor Yellow
			Write-Host "************" -ForegroundColor Yellow
			$goodCount = $goodCount + 1
		}
	}
	While (
		$YourAnswer -ne 1 -and $YourAnswer -ne 2 -and $YourAnswer -ne 3 -and $YourAnswer -ne 4 -and $YourAnswer -ne "Q" 
	)
	
	If ($YourAnswer -eq "q"){
		Break
	}
	$Count = $Count + 1
}
If ($Count -gt 0){
	$Count = $Count -1
}
"You got $goodCount questions correct out of $Count - Total number availble is $numOfQuestions"


##############################################################################################

$finishTime = Get-Date
$totalTime = $finishTime.subtract($startTime).TotalMinutes
Write-Host "Script is complete:"
Write-Host "Time to run was $totalTime minutes"

##################################################################################
##################################################################################
