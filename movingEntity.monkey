import utils

'This class is the parent of every moving thing in the game
Class MovingEntity

	Field m_originalPos:Vec2D
	Field m_position:Vec2D
	Field m_velocity:Vec2D

	Field m_size:Int

	Method New(x:float, y:float)
		self.m_originalPos 	= new Vec2D(x, y)
		self.m_position 	= new Vec2D(x, y)
		self.m_velocity		= new Vec2D(x, y)
	End

	Method Update(_gravity:Float)
		self.m_velocity.x = 0
		self.m_velocity.y += _gravity

		'We put the new position on x/y, then, we cap this position to the screen limit
		self.m_position.x += self.m_velocity.x
		self.m_position.y += self.m_velocity.y
	End

	Method SetVelocityX( _velocity:Int )
		self.m_velocity.x = _velocity
	End

	Method SetVelocityY( _velocity:Int )
		self.m_velocity.y = _velocity
	End

	Method GetSize:int ()
		return self.m_size
	End

	Method GetPosX:Float()
		return Self.m_position.x
	End

	Method GetPosY:Float()
		return Self.m_position.y
	End

	'GetMinPosX and GetMaxPosX return the value on the position of the moving object taking in account the size of the object
	Method GetMinPosX:float()
		return Self.m_position.x - (Self.m_size / 2)
	End

	Method GetMaxPosX:float()
		return Self.m_position.x + (Self.m_size / 2)
	End

	Method GetMinPosY:float()
		return Self.m_position.y - (Self.m_size / 2)
	End

	Method GetMaxPosY:float()
		return Self.m_position.y + (Self.m_size / 2)
	End

End
