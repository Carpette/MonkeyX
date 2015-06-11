Import mojo
Import utils
Import movingEntity

Class Player Extends MovingEntity
	
	Field	m_speed:Float	= 4.0
	Field	m_leftKey:Int
	Field	m_rightKey:Int
	Field	m_upKey:Int

	Method New(_leftKey:Int, _rightKey:Int, x:float, y:float)
		self.m_originalPos 	= new Vec2D(x, y)
		self.m_position 		= new Vec2D(x, y)
		self.m_velocity		= new Vec2D(x, y)

		Self.m_leftKey 	= _leftKey
		Self.m_rightKey	= _rightKey
		Self.m_upKey	= KEY_UP
		Self.m_size		= 32
	End

	Method Reset()
		self.m_position.Set( self.m_originalPos.x, self.m_originalPos.y )
		self.m_velocity.Set( 0, 0 )
	End

	Method Update(_gravity:Float)
		self.m_velocity.x = 0
		self.m_velocity.y += _gravity

		If KeyDown( self.m_leftKey )
			self.m_velocity.x = -m_speed
		End
		If KeyDown( self.m_rightKey )
			self.m_velocity.x	= self.m_speed
		End
		If KeyDown( self.m_upKey ) and self.m_position.y = 464.0
			self.m_velocity.y	= -m_speed *2
		End

		'We put the new position on x/y, then, we cap this position to the screen limit (with a left/right alternance only)
		self.m_position.x += self.m_velocity.x
		If self.m_position.x < ( self.m_size / 2 )
			self.m_position.x = DeviceWidth - self.m_size / 2
		End
		If self.m_position.x > ( DeviceWidth - self.m_size / 2 )
			self.m_position.x = self.m_size / 2
		End

		self.m_position.y += self.m_velocity.y
		If self.m_position.y > ( DeviceHeight - self.m_size / 2 )
			self.m_position.y = DeviceHeight - self.m_size / 2
		End
	End

	Method Draw()
		SetColor(0, 255, 0)
		DrawRect( self.m_position.x - self.m_size / 2, self.m_position.y - self.m_size / 2, self.m_size, self.m_size)
	End
End