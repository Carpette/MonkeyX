Import mojo
Import utils
Import movingEntity

Class Player Extends MovingEntity
	
	Field	m_baseSpeed	:Float	= 4.0
	Field	m_leftKey	:Int
	Field	m_rightKey	:Int
	Field	m_upKey		:Int

	Method New(_leftKey:Int, _rightKey:Int, x:float, y:float)
		m_originalPos 	= new Vec2D(x, y)
		m_position 		= new Vec2D(x, y)
		m_velocity		= new Vec2D(x, y)

		m_leftKey 	= _leftKey
		m_rightKey	= _rightKey
		m_upKey		= KEY_UP
		m_size		= 32
	End

	Method Reset()
		m_position.Set( m_originalPos.x, m_originalPos.y )
		m_velocity.Set( 0, 0 )
	End

	Method Update(_gravity:Float)
		m_velocity.x = 0
		m_velocity.y += _gravity

		If KeyDown( m_leftKey )
			m_velocity.x = -m_baseSpeed
		End
		If KeyDown( m_rightKey )
			m_velocity.x	= m_baseSpeed
		End
		If KeyDown( m_upKey ) and m_position.y = 464.0
			m_velocity.y	= -m_baseSpeed *2
		End

		'We put the new position on x/y, then, we cap this position to the screen limit (with a left/right alternance only)
		m_position.x += m_velocity.x
		If m_position.x < ( m_size / 2 )
			m_position.x = m_size / 2
		End
		If m_position.x > ( DeviceWidth - m_size / 2 )
			m_position.x = DeviceWidth - m_size / 2
		End

		m_position.y += m_velocity.y
		If m_position.y > ( DeviceHeight - m_size / 2 )
			m_position.y = DeviceHeight - m_size / 2
		End
	End

	Method Draw()
		SetColor(0, 255, 0)
		DrawRect( m_position.x - m_size / 2, m_position.y - m_size / 2, m_size, m_size)
	End
End