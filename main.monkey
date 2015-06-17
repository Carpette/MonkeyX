import movingEntity
Import player
Import bullet
Import menu
Import progressBar

Class konApp Extends App

	Const STATE_MENU:Int 	= 0
	Const STATE_GAME:Int 	= 1
	Const STATE_DEATH:Int	= 2

	Const MAX_BULLETS		= 15

	Field	m_gameState		= 0
	'Used to register the 10 first keyhit combo
	Field	m_keyHits:Int[10]
	'Used to update the spiral
	Field	m_updateCount:Int 			= 0
	'Used to control the we only take the first 10 keys
	Field	m_keyHitCount:Int 			= 0
	'Allowing to increase or deacrease the refresh rate
	Field	m_refreshStep:Int			= 5
	'Managing difficulty of the game step by step
	Field	m_step:Int					= 0
	'Registering the time in millisec when the player starts his game
	Field	m_startTime:Int				= 0
	'Well ... obviously, the game score
	Field	m_score:Int					= 0
	'Determining the actual game lvl (used to move on in the game)'
	Field	m_gameLvl:Int				= 1

	Field	m_gravity:float				= 0.2
	'Shhhh, this is secret
	Field	m_konamiImage:Image
	Field	m_konamiSound:Sound
	Field	m_achievementUnlocked:Bool 	= false

	Field	m_player:Player 			= New Player(KEY_LEFT, KEY_RIGHT, 320, 320)
	Field	m_bullets:Bullet[MAX_BULLETS]
	Field	m_progressBar:ProgressBar
	
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

		DrawImage m_konamiImage, l_delta, l_delta
	End
	
	'@Desc Used to display the Konami achievement on the screen just after it's been unlocked
	'@author Q.Sixt
	Method DisplayKonamiAchievement:void()
		m_achievementUnlocked = true
	End
	
	'@Desc Updating the keyHits and calling appropriates methods, depending the situation
	'@author Q.Sixt
	Method UpdateKeyHit:void()
		Repeat
			Local l_char = GetChar()
			If Not l_char
				Exit
			Endif
			If m_keyHitCount < 10
				m_keyHits[m_keyHitCount] = l_char
			Endif
			m_keyHitCount += 1
			
			'If 10 letters have been put in the array, we can check for Konami
			If m_keyHitCount = 10
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
			
						DisplayKonamiAchievement()
						m_konamiImage 	= LoadImage( "Achievement.png" )
						PlaySound( m_konamiSound )
				Else
		
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
			l_RndHeight = 0 + m_player.GetSize()
		End

		l_velocity			= ((l_speed/2) + 1) * 2

		'If the bullet appears the others side of the screen, we reverse the speed (so it can go backwards)
		If l_RndLeftRight > 0.5
			l_xStartPosition = DeviceWidth() - 1
			l_speed = -l_speed
		End

		l_yStartPosition 	= 480 - l_RndHeight

		m_bullets[_speed - 1]	= New Bullet(KEY_LEFT, KEY_RIGHT, l_xStartPosition, l_yStartPosition, l_velocity)
	End

	Method OnCreate()
		SetUpdateRate 60
		m_step = 1
		m_konamiSound	= LoadSound( "Konami.wav")
	End

	'@desc return true if player is in a collision against any bullet
	Method IsPlayerColliding:Bool()
		local i:Int = 0
		Local l_PlayerMinPosY	= m_player.GetMinPosY()
		Local l_PlayerMinPosX	= m_player.GetMinPosX()
		Local l_PlayerMaxPosY	= m_player.GetMaxPosY()
		Local l_PlayerMaxPosX	= m_player.GetMaxPosX()

		'For each bullet
		While i < m_step

			Local l_isCollidingOnX	= false
			Local l_isCollidingOnY	= false
			Local l_minPos = m_bullets[i].GetMinPosX()
			Local l_maxPos = m_bullets[i].GetMaxPosX()
			
			'If the position of the Bullet is beetween the min and max of the player, then, collision
			If ((l_PlayerMinPosX < l_maxPos and l_PlayerMinPosX > l_minPos) or
				(l_PlayerMaxPosX < l_maxPos and l_PlayerMaxPosX > l_minPos) or
				(l_PlayerMinPosX < l_maxPos and l_PlayerMaxPosX > l_maxPos) or
				(l_PlayerMinPosX < l_minPos and l_PlayerMaxPosX > l_minPos))
				'Ok, if we're here, that means the X position is colliding. Let's check the Y position
				l_isCollidingOnX = true
			End
			l_minPos = m_bullets[i].GetMinPosY()
			l_maxPos = m_bullets[i].GetMaxPosY()

			If ((l_PlayerMinPosY < l_maxPos and l_PlayerMinPosY > l_minPos) or
				(l_PlayerMaxPosY < l_maxPos and l_PlayerMaxPosY > l_minPos) or
				(l_PlayerMinPosY < l_maxPos and l_PlayerMaxPosY > l_maxPos) or
				(l_PlayerMinPosY < l_minPos and l_PlayerMaxPosY > l_minPos))
				l_isCollidingOnY = true
			End

			'If we got collision on both X and Y, that means we're really in a collision
			If l_isCollidingOnY And l_isCollidingOnX
				return True
			End
			i += 1
		Wend

		return false
	End
	
	Method OnUpdate()
		UpdateKeyHit()
		
		Select m_gameState
			Case STATE_MENU
				If KeyHit(KEY_ENTER)
					Local l_position:Vec2Di	= new Vec2Di(300, 20)
					Local l_size:Vec2Di		= new Vec2Di(80, 20)
					m_gameState = STATE_GAME
					m_startTime = Millisecs
					m_progressBar = New ProgressBar("Progression: ", (Millisecs - m_startTime), 40000 , l_position, l_size, [10.0,10.0,10.0], [150.0,150.0,105.0])
					CreateNewBullet( m_step, true )
				End
			Case STATE_GAME
				Local l_Progression:Float = Millisecs - m_startTime
				m_progressBar.Update(l_Progression)
				m_player.Update( m_gravity )

				'we step-up every 8 seconds
				If (l_Progression / 1000) > m_step * 8 and m_step < MAX_BULLETS
					m_step += 1
					CreateNewBullet(m_step)
				End

				local i:Int = 0
				While i < m_step
					m_bullets[i].Update(0.0)
					i += 1
				Wend

				'Let's see now if the player is colliding against a bullet. If so, that's the end
				If IsPlayerColliding()
					m_score = l_Progression
					PlaySound( m_konamiSound )
					i = 0
					m_gameState = 2
					While i < m_step
						'm_bullets[i] =  @TODO: détruire les balles présentes
						i += 1
					Wend
					m_step = 1
				End

			Case STATE_DEATH
				If KeyHit(KEY_ENTER)
					m_gameState = STATE_MENU
				End
		End
	End
	
	Method OnRender()
		Cls
		Select m_gameState

			Case STATE_MENU
				DrawSpiral m_updateCount
				DrawSpiral m_updateCount*1.1
				DrawText ("Press enter to start", (DeviceWidth -100) / 2, DeviceHeight / 2)

			Case STATE_GAME
				m_progressBar.Draw()
				m_player.Draw()
				local i:Int = 0
				While i < m_step

					m_bullets[i].Draw()
					i += 1
				Wend
			Case STATE_DEATH
				DrawText ("Game Over", (DeviceWidth -TextWidth("Game Over")) / 2, DeviceHeight / 2)
				DrawText ("Score : " + m_score, (DeviceWidth - TextWidth("Score : " + m_score)) / 2, DeviceHeight / 2)

		End
		'We display the konami, no matter the actual state
		If( m_achievementUnlocked )
			DrawKonami( m_updateCount )
		Endif
	End
	
End

Function Main:Int()
	New konApp
	
	Return 0
End