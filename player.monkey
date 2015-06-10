Import mojo

Class Vec2D
	Field x:Float
	Field y:Float

	Method New(x:Float = 0, y:Float = 0)
		Set(x, y)
	End

	Method Set(x:Float, y:Float)
		Self.x = x
		Self.y = y
	End
End

Class Vec2Di
	Field x:Int
	Field y:Int

	Method New(x:Int = 0, y:Int = 0)
		Set(x, y)
	End

	Method Set(x:Int, y:Int)
		Self.x = x
		Self.y = y
	End
End

Class Player
	Field m_originalPos:Vec2D
	Field m_position:Vec2D
	Field m_velocity:Vec2D
	
	Field m_speed:Float	= 4.0
	Field m_leftKey:Int
	Field m_rightkey:Int

	Method New(_leftKey:Int, _rightKey:Int, x:float, y:float)
		m_originalPos 	= new Vec2D(x, y)
		m_position 		= new Vec2D(x, y)
		m_velocity		= new Vec2D(x, y)

		Self.m_leftKey 	= _leftKey
		Self.m_rightkey	= _rightKey
	End

	Method Reset()
		m_position.Set( m_originalPos.x, m_originalPos.y )
		m_velocity.Set( 0, 0 )
	End

	Method Update(_gravity:Float)
		m_velocity.x = 0
		m_velocity.y += _gravity

		if KeyDown( m_leftKey )
			m_velocity.x = -m_speed
		End
		if KeyDown( m_rightkey )
			m_velocity.x	= m_speed
		End

		m_position.x += m_velocity.x
		m_position.y += m_velocity.y
	End

	Method Draw()
		SetColor(0, 255, 0)
		DrawRect( m_position.x - 16, m_position.y - 16, 32, 32)
	End
End