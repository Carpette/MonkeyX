Import player

Class konApp Extends App

	Field	m_keyHits:Int[10]

	Field	m_updateCount:Int 			= 0
	Field	m_letterCount:Int 			= 0
	Field	m_refreshStep:Int			= 5

	Field	m_gravity:float				= 0.2

	Field	m_konamiImage:Image
	Field	m_konamiSound:Sound

	Field	m_achievementUnlocked:Bool 	= false

	Field	m_player:Player 			= New Player(KEY_LEFT, KEY_RIGHT, 320, 50)
	
	'@desc Function used to draw waves on the background
	'@author Q.Sixt (based on MonkeyX tutorials)
	Function DrawSpiral:void( _clock )
		Local w = DeviceWidth / 2
		For Local i#=0 Until w*1.5 Step .2
			Local x#,y#
			x = w + i * Sin( i * 3 + _clock )
			y = w + i * Cos( i * 2 + _clock )
			DrawPoint x,y
		Next
	End

	'@desc used do draw Konami Code
	'@author Q.Sixt
	method drawKonami:void( _clock )
		Local l_widthCenter:Int 	= DeviceWidth / 2
		Local l_heightCenter:Int	= DeviceHeight / 2
		Local l_delta:Int 			= Rnd (0, _clock) / 40

		DrawImage m_konamiImage, l_delta, l_delta
	End
	
	'@Desc Used to display the Konami achievement on the screen just after it's been unlocked
	'@author Q.Sixt
	Method displayKonamiAchievement:void()
		m_achievementUnlocked = true
	End
	
	'@Desc Updating the keyHits and calling appropriates methods, depending the situation
	'@author Q.Sixt
	Method updateKeyHit:void()
		Repeat
			Local l_char = GetChar()
			If Not l_char
				Exit
			Endif
			If m_letterCount < 10
				m_keyHits[m_letterCount] = l_char
			Endif
			m_letterCount += 1
			
			'If 10 letters have been put in the array, we can check for Konami
			If m_letterCount = 10
				If( m_keyHits[0] = 65574 And
					m_keyHits[1] = 65574 And
					m_keyHits[2] = 65576 And
					m_keyHits[3] = 65576 And
					m_keyHits[4] = 65573 And
					m_keyHits[5] = 65575 And
					m_keyHits[6] = 65573 And
					m_keyHits[7] = 65575 And
					m_keyHits[8] = 98 And
					m_keyHits[9] = 97 )
						Print "Konami achieved !"
						displayKonamiAchievement()
						m_konamiImage 	= LoadImage( "Achievement.png" )
						m_konamiSound	= LoadSound( "Konami.wav")
						PlaySound( m_konamiSound )
				Else
					Print "Konami raté"
				Endif
			End
		Forever
		
		'If upArrow key has been hit, we accellerate the drawing frequency
		Local l_upHit = KeyHit( KEY_UP )
		If l_upHit
			'We don't need to have more than 60 FPS on this demo
			If( UpdateRate + m_refreshStep < 65)
				SetUpdateRate UpdateRate + m_refreshStep
			End
		End
		
		'If downArrow key has been hit, we slow down the drawing frequency
		Local l_downHit = KeyHit( KEY_DOWN )
		If l_downHit
			'Let's not slow down too much. Engine seems to crash if we reach 0
			If( UpdateRate - m_refreshStep > 0)
				SetUpdateRate UpdateRate - m_refreshStep
			End
		End
		
		m_updateCount+=1
	End

	Method OnCreate()
		SetUpdateRate 60
	End
	
	Method OnUpdate()
		updateKeyHit()
		m_player.Update( m_gravity )
	End
	
	Method OnRender()
		Cls
		DrawSpiral m_updateCount
		DrawSpiral m_updateCount*1.1
		If( m_achievementUnlocked )
			drawKonami( m_updateCount )
		Endif
		m_player.Draw()
	End
	
End

Function Main:Int()
	New konApp
	
	Return 0
End