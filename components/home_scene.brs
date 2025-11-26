function init()
    ? "[home_scene] init"
    m.control = ""

    'initalizing global variables
    m.global = {}
    m.global.userSettings = { fontSize: 30, language: "en" }
    m.global.fontofButtons = CreateObject("roSGNode", "Font")
    m.global.fontofButtons.uri = "pkg:/fonts/BubblePixel2.ttf"
    m.global.fontofButtons.size = m.global.userSettings.fontSize
    m.global.translations = {
        "en": {
            "START": "START",
            "CHARACTER": "CHARACTER",
            "SETTINGS": "SETTINGS",
            "TEXT_SIZE": "Text Size",
            "LANGUAGE": "Language",
            "INCREASE": "Increase",
            "DECREASE": "Decrease",
            "SKIP": "SKIP",
            "EGYPT": "EGYPT",
            "PANGEA": "PANGEA",
            "EUROPE": "EUROPE"

        },
        "es": {
            "START": "COMENZAR",
            "CHARACTER": "PERSONAJE",
            "SETTINGS": "CONFIGURACIONES",
            "TEXT_SIZE": "Tamano de texto",
            "LANGUAGE": "Idioma",
            "INCREASE": "Aumentar",
            "DECREASE": "Disminuir",
            "SKIP": "SALTAR",
            "EGYPT": "EGIPTO",
            "PANGEA": "PANGEA",
            "EUROPE": "EUROPA"
        }, 
        "fr": {
            "START": "COMMENCER",
            "CHARACTER": "PERSONNAGE",
            "SETTINGS": "PARAMETRES",
            "TEXT_SIZE": "Taille du texte",
            "LANGUAGE": "Langue",
            "INCREASE": "Augmenter",
            "DECREASE": "Diminuer",
            "SKIP": "SAUTER",
            "EGYPT": "EGYPTE",
            "PANGEA": "PANGEE",
            "EUROPE": "L'EUROPE"

        }
        
    }
    m.global.currentLanguage = "en" 'default language

    'initializing all nodes (screens, button lists, video)
    m.category_screen = m.top.findNode("category_screen")
    m.level_screen = m.top.findNode("level_screen")
    m.settings_screen = m.top.findNode("settings_screen")
    m.characters_screen = m.top.findNode("characters_screen")
    m.meteor_screen = m.top.findNode("meteor_screen")
    m.level1_screen = m.top.findNode("level1_screen")
    m.level2_screen = m.top.findNode("level2_screen")
    m.level3_screen = m.top.findNode("level3_screen")

    m.category_list = m.top.findNode("category_list")
    m.levelButtons = m.top.findNode("levelButtons")
    m.video = m.top.findNode("video")
    m.skip_button = m.top.findNode("skipButton")
    m.settings_list = m.top.findNode("settings_list")
    m.fontSizeButtons = m.top.findNode("fontSizeButtons")
    m.languageButtons = m.top.findNode("languageButtons")
    m.error_dialog = m.top.findNode("error_dialog")
    
    'category screen
    m.category_list.observeField("buttonSelected", "onCategorySelected")
    m.category_list.buttons = ["START","CHARACTER","SETTINGS"]
    m.categoryRect = m.category_list.boundingRect()
    m.category_screen.visible = true
    m.category_screen.setFocus(true)

    'settings screen
    m.settings_list.buttons = ["TEXT SIZE", "LANGUAGE"]
    m.fontSizeButtons.buttons = ["Increase", "Decrease"]
    m.languageButtons.buttons = ["English", "Espanol", "Francais"]
    m.settings_list.observeField("buttonSelected", "onSettingsButtonSelected")
    m.fontSizeButtons.observeField("buttonSelected", "onFontSizeButtonSelected")
    m.languageButtons.observeField("buttonSelected", "onLanguageButtonSelected")

    'level buttons set up
    m.levelButtons = m.top.findNode("levelButtons")
    m.levelButtons.observeField("buttonSelected", "onLevelSelected")
    m.levelButtons.buttons = ["EGYPT","PANGEA","EUROPE"]
    m.levelRect = m.levelButtons.boundingRect()
    m.levelButtons.visible = false
    m.levelButtons.setFocus(false)

    'skip button for videos
    m.skip_button.buttons = ["SKIP"]
    m.skipRect = m.skip_button.boundingRect()
    m.skip_button.setFocus(true)
    m.skip_button.observeField("buttonSelected", "skipbuttonSelected")
    m.skip_button.visible = false

    'category list fonts
    m.category_list.textFont = m.global.fontofButtons
    m.category_list.focusedTextFont = m.global.fontofButtons

    'level list fonts
    m.levelButtons.textFont = m.global.fontofButtons
    m.levelButtons.focusedTextFont = m.global.fontofButtons

    'skip button fonts
    m.skip_button.textFont = m.global.fontofButtons
    m.skip_button.focusedTextFont = m.global.fontofButtons

    'setting screen fonts
    m.categoryRect = m.settings_list.boundingRect()
    m.settings_list.textFont = m.global.fontofButtons
    m.settings_list.focusedTextFont = m.global.fontofButtons
    m.fontSizeButtons.textFont = m.global.fontofButtons
    m.fontSizeButtons.focusedTextFont = m.global.fontofButtons
    m.languageButtons.textFont = m.global.fontofButtons
    m.languageButtons.focusedTextFont = m.global.fontofButtons

    m.level1_screen.observeField("switchToLevelScreen", "toLevelScreen")
    m.level2_screen.observeField("switchToLevelScreen2", "toLevelScreen2")
    m.level3_screen.observeField("switchToLevelScreen3", "toLevelScreen3")

    m.level_screen.observeField("switchToMeteorScreen", "toMeteorScreen")

    'figuring out level variable stuff
    m.currentLevel = 0

    'indexes
    m.categoryIndex = -1
    m.level_index = 0
    m.skipIndex = 0

    'sets up category screen
    playBackgroundVideo()
    m.category_list.setFocus(true) 'sets the category list to true AFTER the video is playing
end function


sub toLevelScreen()
    m.level1_screen.visible = false

    m.level_screen.visible = true
    m.level_screen.setFocus(true)
    m.levelButtons.visible = true
    m.levelButtons.setFocus(true)
end sub


sub toLevelScreen2()
    m.level2_screen.visible = false

    m.level_screen.visible = true
    m.level_screen.setFocus(true)
    m.levelButtons.visible = true
    m.levelButtons.setFocus(true)
end sub


sub toLevelScreen3()
    m.level3_screen.visible = false

    m.level_screen.visible = true
    m.level_screen.setFocus(true)
    m.levelButtons.visible = false
    m.levelButtons.setFocus(false)
end sub


sub toMeteorScreen()

    m.meteor_screen.visible = true
    m.meteor_screen.setFocus(true)
    m.level_screen.setFocus(false)
    m.level_screen.visible = false

    ? "meteor screen is visible"

end sub 

sub skipbuttonSelected (obj)
    if m.skip_button.buttonSelected = 0 then
        m.video.visible = false
        m.video.control = "stop"
        m.skip_button.visible = false
        if m.skipIndex = 0 'intro vid
            m.levelButtons.visible = true
            m.levelButtons.setFocus(true)
            m.level_screen.visible = true

        else if m.skipIndex = 1 'level 1
            m.level1_screen.visible = true
            m.level2_screen.visible = false
            m.level3_screen.visible = false

            m.level1_screen.setFocus(true)

        else if m.skipIndex = 2 'level 2
            m.level1_screen.visible = false
            m.level2_screen.visible = true
            m.level3_screen.visible = false

            m.level2_screen.setFocus(true)

        else if m.skipIndex = 3 'level 3
            m.level1_screen.visible = false
            m.level2_screen.visible = false
            m.level3_screen.visible = true

            m.level3_screen.setFocus(true)

        end if
    end if
end sub 


sub onCategorySelected(obj)
    ? "onCategorySelected field: "; obj.getField()
    ? "onCategorySelected data: "; obj.getData()

    m.categoryIndex = m.category_list.buttonSelected

    if m.categoryIndex = 0 'start is clicked
        m.category_screen.visible = false
        m.category_list.visible = false
        m.level_screen.visible = true

        m.category_screen.setFocus(false)
        m.level_screen.setFocus(true)
        m.levelButtons.setFocus(true)

        playIntroVideo()

        m.skip_button.visible = true
        m.skip_button.setFocus(true)

    else if m.categoryIndex = 1 'characters is clicked
        m.characters_screen.visible = true

        m.category_screen.visible = false
        m.category_list.visible = false
        m.video.visible = false
        m.video.setFocus(false)
        
        m.characters_screen.setFocus(true)

    else if m.categoryIndex = 2 'settings is clicked
        m.settings_screen.visible = true
        m.settings_list.visible = true
        m.settingsIndex = 0

        m.category_screen.visible = false
        m.category_list.visible = false
        m.video.visible = false
        m.video.setFocus(false)
        
        m.settings_screen.setFocus(true)
        m.settings_list.setFocus(true)
    end if
end sub


function onKeyEvent(key, press) as Boolean
    ? "[home_scene] onKeyEvent", key, press
    if key = "back" and press
        if m.level_screen.visible
            m.level_screen.visible = false
            m.levelButtons.visible = false

            m.category_screen.visible = true
            m.category_screen.setFocus(true)
            m.category_list.visible = true
            m.category_list.setFocus(true)
            
            playBackgroundVideo()
            return true

        else if m.fontSizeButtons.visible
            m.fontSizeButtons.visible = false

            m.settings_list.visible = true
            m.settings_list.setFocus(true)
            return true

        else if m.languageButtons.visible
            m.languageButtons.visible = false

            m.settings_list.visible = true
            m.settings_list.setFocus(true)
            return true

        else if m.settings_list.visible
            m.settings_screen.visible = false
            m.settings_list.visible = false
                
            m.category_screen.visible = true
            m.category_screen.setFocus(true)
            m.category_list.visible = true
            m.category_list.setFocus(true)

            playBackgroundVideo()
            return true

        else if m.characters_screen.visible
            m.characters_screen.visible = false

            m.category_screen.visible = true
            m.category_screen.setFocus(true)
            m.category_list.visible = true
            m.category_list.setFocus(true)
            
            playBackgroundVideo()
            return true
        end if
    end if
 
    if m.level_screen.visible
        if press = true then
            if key = "right"
                m.level_index = m.level_index + 1
                if m.level_index > 2
                    m.level_index = 0
                end if
                m.levelButtons.focusButton = m.level_index
                return true

            else if key = "left"
                m.level_index = m.level_index - 1
                if m.level_index < 0 
                    m.level_index = 2
                end if
                m.levelButtons.focusButton = m.level_index
                return true

            else if key = "up"
                m.levelButtons.focusButton = m.level_index
                return true

            else if key = "down"
                m.levelButtons.focusButton = m.level_index
                return true
            end if
            m.levelButtons.focusButton = m.level_index 
        end if
    end if
  return false
end function


sub onLevelSelected(obj)
    m.currentLevel = m.levelButtons.buttonSelected
    
    m.level_screen.visible = false
    m.level_screen.setFocus(false)
    m.levelButtons.setFocus(false)
    m.levelButtons.visible = false

    if m.currentLevel = 0 'level 1 is clicked
        playLevelOneVideo()
        m.skip_button.visible = "true"
        m.skip_button.setFocus(true)
        

    else if m.currentLevel = 1 'level 2 is clicked
        playLevelTwoVideo()
        m.skip_button.visible = "true"
        m.skip_button.setFocus(true)

    else if m.currentLevel = 2 'level 3 is clicked
        playLevelThreeVideo()
        m.skip_button.visible = true
        m.skip_button.setFocus(true)
    end if

end sub


function preloadVideo(videoNode, videoUrl)
    ? "Preloading video: "; videoUrl
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = videoUrl
    videoContent.streamFormat = "mp4"
    
    videoNode.content = videoContent
    videoNode.observeField("state", "onVideoPreloadStateChange")
    videoNode.control = "preload"
end function


sub onVideoPreloadStateChange(event as Object)
    ? "Video preload state: "; event.getData()
    if event.getData() = "preloaded"
        ? "Video preloaded successfully"
    else if event.getData() = "error"
        ? "Error preloading video"
    end if
end sub


function playBackgroundVideo()
    'm.bgVideo = m.top.findNode("bgVideo")
    ? "bgVideo node: "; m.video

    preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/spacebgLONG.mp4")
    
    'set the video to play once preloading is done
    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)

    m.category_list.setFocus(true)
    if m.video.state = "finished"
        m.video.control = "play"
    end if
end function


function playIntroVideo()
    ? "playing intro video"
    m.skipIndex = 0
    if m.global.currentLanguage = "fr"
        preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/FrenchIntroWmusic.mov")
    else
        preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/intro_animation.mp4")
    end if

    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)
    m.video.observeField("state", "onIntroVideoStateChange")
end function


sub onIntroVideoStateChange()
    ? "Intro video state: "; m.video.state
    if m.video.state = "error"
        ? "Error playing intro video: "; m.video.errorMsg
    else if m.video.state = "finished"
        ? "Intro video finished"
        m.video.visible = false

        ? "levelbuttons made visible"
        m.skip_button.visible = false
        m.levelButtons.visible = true
        m.levelButtons.setFocus(true)

        ? "level screen made visible"
        m.level_screen.visible = true
    end if
end sub


function playLevelOneVideo()
    ? "playing level one video"
    m.skipIndex = 1
    preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/LevelOne.mp4")

    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)
    m.video.observeField("state", "onLevelVideoStateChange")
end function


function playLevelTwoVideo()
    ? "playing level two video"
    m.skipIndex = 2
    preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/LevelTwo.mp4")

    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)
    m.video.observeField("state", "onLevelVideoStateChange")
end function


function playLevelThreeVideo()
    ? "playing level two video"
    m.skipIndex = 3
    preloadVideo(m.video, "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/LevelThree.mp4")

    m.video.visible = true
    m.video.control = "play"
    m.video.setFocus(true)
    m.video.observeField("state", "onLevelVideoStateChange")
end function


sub onLevelVideoStateChange()
    ? "level video state: "; m.video.state
    if m.video.state = "error"
        ? "error playing level video: "; m.video.errorMsg

    else if m.video.state = "finished"
        ? "level video finished"
        m.video.visible = false

        ? "levels screen made visible"
        m.level_screen.visible = false
        m.skip_button.visible = false
        m.levelButtons.visible = false

        if m.currentLevel = 0
            m.level1_screen.visible = true
            m.level2_screen.visible = false
            m.level3_screen.visible = false

            m.level1_screen.setFocus(true)
        else if m.currentLevel = 1
            m.level1_screen.visible = false
            m.level2_screen.visible = true
            m.level3_screen.visible = false

            m.level2_screen.setFocus(true)
        else if m.currentLevel = 2
            m.level1_screen.visible = false
            m.level2_screen.visible = false
            m.level3_screen.visible = true

            m.level3_screen.setFocus(true)
        end if      
    end if
end sub


sub onSettingsButtonSelected(obj)
    ? "onSettingsButtonSelected is being called"
    m.settingsButtonIndex = m.settings_list.buttonSelected

    if m.settingsButtonIndex = 0 'text size is clicked
        m.settings_list.visible = false
        m.fontSizeButtons.visible = true
        m.fontSizeButtons.setFocus(true)
        
    else if m.settingsButtonIndex = 1 'language is clicked
        m.settings_list.visible = false
        m.languageButtons.visible = true
        m.languageButtons.setFocus(true)
    end if
end sub


sub onFontSizeButtonSelected(obj)
    ? "font size button option was selected"
    m.fontButtonIndex = m.fontSizeButtons.buttonSelected

    if m.fontButtonIndex = 0 'increase is selected
        m.global.userSettings.fontSize += 5
        ? "increase font size was selected!"
    else if m.fontButtonIndex = 1 'decrease is selected
        m.global.userSettings.fontSize -= 5
        ? "decrease font size was selected!"
    end if

    'updates font size across the app
    m.global.fontofButtons.size = m.global.userSettings.fontSize
    m.category_list.textFont = m.global.fontofButtons
    m.category_list.focusedTextFont = m.global.fontofButtons
    m.levelButtons.textFont = m.global.fontofButtons
    m.levelButtons.focusedTextFont = m.global.fontofButtons
    m.skip_button.textFont = m.global.fontofButtons
    m.skip_button.focusedTextFont = m.global.fontofButtons
    m.settings_list.textFont = m.global.fontofButtons
    m.settings_list.focusedTextFont = m.global.fontofButtons
    m.fontSizeButtons.textFont = m.global.fontofButtons
    m.fontSizeButtons.focusedTextFont = m.global.fontofButtons
end sub


sub onLanguageButtonSelected(obj)
    selectedLanguageIndex = m.languageButtons.buttonSelected
    if selectedLanguageIndex = 0
        m.global.currentLanguage = "en"
        showErrorDialog("Language has been updated!", "LANGUAGE UPDATE")
    else if selectedLanguageIndex = 1
        m.global.currentLanguage = "es"
        showErrorDialog("El idioma ha sido actualizado!", "ACTUALIZACION DE IDIOMA")
    else if selectedLanguageIndex = 2
        m.global.currentLanguage = "fr"
        showErrorDialog("La langue a ete mise a jour!", "MISE A JOUR DE LA LANGUE")
    end if
    updateLanguage()
end sub


sub updateLanguage()
    m.category_list.buttons = [
        m.global.translations[m.global.currentLanguage]["START"],
        m.global.translations[m.global.currentLanguage]["CHARACTER"],
        m.global.translations[m.global.currentLanguage]["SETTINGS"]
    ]
    m.settings_list.buttons = [
        m.global.translations[m.global.currentLanguage]["TEXT_SIZE"],
        m.global.translations[m.global.currentLanguage]["LANGUAGE"]
    ]
    m.fontSizeButtons.buttons = [
        m.global.translations[m.global.currentLanguage]["INCREASE"],
        m.global.translations[m.global.currentLanguage]["DECREASE"]
    ]
    m.languageButtons.buttons = [
        "English",
        "Espanol",
        "Francais"
    ]
    m.levelButtons.buttons = [
        m.global.translations[m.global.currentLanguage]["EGYPT"],
        m.global.translations[m.global.currentLanguage]["PANGEA"],
        m.global.translations[m.global.currentLanguage]["EUROPE"]
    ]
    m.skip_button.buttons = [
        m.global.translations[m.global.currentLanguage]["SKIP"]
    ]

    if m.global.currentLanguage = "fr"
        m.settings_screen.url = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/French_SETTINGS_screen.png"
    else if m.global.currentLanguage = "es"
        m.settings_screen.url = "https://kingsfortress-3e1c1a41ac2a.herokuapp.com/images/Spanish_SETTINGS_screen.png"
    end if
end sub


sub showErrorDialog(message, title)
	m.error_dialog.title = title
	m.error_dialog.message = message
	m.error_dialog.visible=true
	'tell the home scene to own the dialog so the remote behaves'
	m.top.dialog = m.error_dialog
end sub