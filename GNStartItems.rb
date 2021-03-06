#
#  GMStartItems.rb
#  Gmail Notifr
#
#  Created by james on 10/5/08.
#  Copyright (c) 2008 ashchan.com. All rights reserved.
#

require 'osx/cocoa'

class GNStartItems < OSX::NSObject

	def	isSet
		cf = OSX::CFPreferencesCopyValue(
			"AutoLaunchedApplicationDictionary",
			"loginwindow",
			OSX::KCFPreferencesCurrentUser,
			OSX::KCFPreferencesAnyHost
		)

		cf.any? { |app| path == app["Path"] }
	end
	
	def	set(autoLaunch)
		if autoLaunch != isSet
			cf = OSX::CFPreferencesCopyValue(
				"AutoLaunchedApplicationDictionary",
				"loginwindow",
				OSX::KCFPreferencesCurrentUser,
				OSX::KCFPreferencesAnyHost
			).mutableCopy
			
			if autoLaunch
				#add
				#cf << { "Path" => path }
				cf.addObject(NSDictionary.dictionaryWithObject_forKey(path, "Path"))
			else
				#remove
				cf.each do |app|
					cf.removeObject(app) and break if app.valueForKey("Path") == path
				end
			end
			
			OSX::CFPreferencesSetValue(
				"AutoLaunchedApplicationDictionary",
				cf,
				"loginwindow",
				OSX::KCFPreferencesCurrentUser,
				OSX::KCFPreferencesAnyHost
			)
			
			OSX::CFPreferencesSynchronize(
				"loginwindow",
				OSX::KCFPreferencesCurrentUser,
				OSX::KCFPreferencesAnyHost
			)
		end
	end
	
	def	path
		@path ||= NSBundle.mainBundle.bundlePath
	end
end
