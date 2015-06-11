import movingEntity
Import player
Import bullet
Import menu

Class konApp Extends App

	Const STATE_MENU:Int 	= 0
	Const STATE_GAME:Int 	= 1
	Const STATE_DEATH:Int	= 2

	Field	m_gameState		= 0

	Field	m_keyHits:Int[10]

	Field	m_updateCount:Int 			= 0
	Field	m_letterCount:Int 			= 0
	Field	m_refreshStep:Int			= 5
	Field	m_step:Int					= 0

	Field	m_gravity:float				= 0.2

	Field	m_konamiImage:Image
	Field	m_konamiSound:Sound

	Field	m_achievementUnlocked:Bool 	= false

	Field	m_player:Player 			= New Player(KEY_LEFT, KEY_RIGHT, 320, 320)
	Field	m_bullets:Bullet[10]
	Field	m_menu:Menu					= new Menu()
	
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
	method DrawKonami:void( _clock )
		Local l_widthCenter:Int 	= DeviceWidth / 2
		Local l_heightCenter:Int	= DeviceHeight / 2
		Local l_delta:Int 			= Rnd (0, _clock) / 40

		DrawImage self.m_konamiImage, l_delta, l_delta
	End
	
	'@Desc Used to display the Konami achievement on the screen just after it's been unlocked
	'@author Q.Sixt
	Method DisplayKonamiAchievement:void()
		Self.m_achievementUnlocked = true
	End
	
	'@Desc Updating the keyHits and calling appropriates methods, depending the situation
	'@author Q.Sixt
	Method UpdateKeyHit:void()
		Repeat
			Local l_char = GetChar()
			If Not l_char
				Exit
			Endif
			If Self.m_letterCount < 10
				Self.m_keyHits[Self.m_letterCount] = l_char
			Endif
			Self.m_letterCount += 1
			
			'If 10 letters have been put in the array, we can check for Konami
			If Self.m_letterCount = 10
				If( Self.m_keyHits[0] = 65574 And
					Self.m_keyHits[1] = 65574 And
					Self.m_keyHits[2] = 65576 And
					Self.m_keyHits[3] = 65576 And
					Self.m_keyHits[4] = 65573 And
					Self.m_keyHits[5] = 65575 And
					Self.m_keyHits[6] = 65573 And
					Self.m_keyHits[7] = 65575 And
					Self.m_keyHits[8] = 98 And
					Self.m_keyHits[9] = 97 )
			
						DisplayKonamiAchievement()
						m_konamiImage 	= LoadImage( "Achievement.png" )
						m_konamiSound	= LoadSound( "Konami.wav")
						PlaySound( self.m_konamiSound )
				Else
		
				Endif
			End
		Forever
		
		'If upArrow key has been hit, we accellerate the drawing frequency
		Local l_upHit = KeyHit( KEY_UP )
		If l_upHit
			'We don't need to have more than 60 FPS on this demo
			If( UpdateRate + Self.m_refreshStep < 65)
				SetUpdateRate UpdateRate + Self.m_refreshStep
			End
		End
		
		'If downArrow key has been hit, we slow down the drawing frequency
		Local l_downHit = KeyHit( KEY_DOWN )
		If l_downHit
			'Let's not slow down too much. Engine seems to crash if we reach 0
			If( UpdateRate - Self.m_refreshStep > 0)
				SetUpdateRate UpdateRate - Self.m_refreshStep
			End
		End
		
		Self.m_updateCount+=1
	End

	'@desc Method used to create new bullets. _first parameter should only be used if it's the first bullet ever generated in the game (to generate it on the ground)
	Method CreateNewBullet( _speed:Int, _first:bool = false )
		Local l_RndLeftRight:float	= Rnd()
		Local l_RndHeight:float		= Rnd(240)
		Local l_xStartPosition:Int	= 0
		Local l_yStartPosition:Int	= 0
		Local l_velocity:Int		= 0
		Local l_speed: Int			= _speed

		'If it's the first bullet we're generating, we force it to be on the ground
		If _first
			l_RndHeight = 0 + self.m_player.GetSize()
		End

		'If the bullet appears the others side of the screen, we reverse the speed (so it can go backwards)
		If l_RndLeftRight > 0.5
			l_xStartPosition = DeviceWidth() - 1
			l_speed = -l_speed
		End

		l_yStartPosition 	= 480 - l_RndHeight
		l_velocity			=  l_speed * 2

		Self.m_bullets[_speed - 1]	= New Bullet(KEY_LEFT, KEY_RIGHT, l_xStartPosition, l_yStartPosition, l_velocity)
	End

	Method OnCreate()
		SetUpdateRate 60
		Self.m_menu = New Menu("Test 1")
		Self.m_step = 1
		CreateNewBullet( Self.m_step, true )
	End

	'@desc return true if player is in a collision against any bullet
	Method IsPlayerColliding:Bool()
		return false
	End
	
	Method OnUpdate()

		UpdateKeyHit()
		
		Select self.m_gameState
			Case STATE_MENU
				If KeyHit(KEY_ENTER)
					self.m_gameState = STATE_GAME
				End
				Self.m_menu.Update()
			Case STATE_GAME
				Self.m_player.Update( Self.m_gravity )

				'we step-up every 8 seconds
				If (Millisecs / 1000) > self.m_step * 8 and m_step < 10
					Self.m_step += 1
					CreateNewBullet(Self.m_step)
				End

				local i:Int = 0
				While i < Self.m_step
					Self.m_bullets[i].Update(0.0)
					i += 1
				Wend

				'Let's see now if the player is colliding against a bullet. If so, that's the end
				If IsPlayerColliding()
					self.m_gameState = 2
				End

			Case STATE_DEATH
		End
	End
	
	Method OnRender()
		Cls
		Select Self.m_gameState

			Case STATE_MENU
				DrawSpiral Self.m_updateCount
				DrawSpiral Self.m_updateCount*1.1
				Self.m_menu.Draw()

			Case STATE_GAME
				Self.m_player.Draw()
				local i:Int = 0
				While i < Self.m_step

					Self.m_bullets[i].Draw()
					i += 1
				Wend
			Case STATE_DEATH

		End
		'We display the konami, no matter the actual state
		If( Self.m_achievementUnlocked )
			DrawKonami( Self.m_updateCount )
		Endif
	End
	
End

Function Main:Int()
	New konApp
	
	Return 0
End