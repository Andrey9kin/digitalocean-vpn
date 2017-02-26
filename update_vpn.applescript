on vpn_status(vpn_name)
	tell application "System Events"
		return connected of configuration of service vpn_name of network preferences
	end tell
end vpn_status

on run argv
	
	set vpn_name to item 1 of argv
	set vpn_address to item 2 of argv
	set vpn_username to item 3 of argv
	set vpn_password to item 4 of argv
	set vpn_secret to item 5 of argv
	
	tell application "System Preferences"
		reveal pane "Network"
		activate
		
		tell application "System Events"
			tell process "System Preferences"
				tell window 1
					-- select the specified row in the service list 
					repeat with r in rows of table 1 of scroll area 1
						if (value of attribute "AXValue" of static text 1 of r as string) contains vpn_name then
							select r
						end if
					end repeat
					
					-- set the address & username / account name
					-- note that this is vpn specific
					tell group 1
						set focused of text field 1 to true
						keystroke ""
						set value of text field 1 to vpn_address
						set focused of text field 2 to true
						keystroke ""
						set value of text field 2 to vpn_username
						click button "Authentication Settings…"
					end tell
					
					-- open up the auth panel and set the login password
					tell sheet 1
						set focused of text field 1 to true
						keystroke ""
						set value of text field 1 to vpn_password
						set focused of text field 2 to true
						keystroke ""
						set value of text field 2 to vpn_secret
						click button "Ok"
					end tell
					
					click button "Apply"
					delay 3
					tell group 1
						click button "Connect"
					end tell
				end tell
			end tell
		end tell
		
		quit
	end tell
end run