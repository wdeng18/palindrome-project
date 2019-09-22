# palindrome-project
Palindrome checker written with ARM-v8

Takes in a string and converts all characters to lower case if they are not and then removes all whitespaces in the string. Then, 
recursively checks the converted string at the start and at the end to see if the string is a palindrome. Can handle numbers and most
common punctuation with the exception of ":", ";", "?" as they are converted to whitespaces instead.
