Import mojo
import utils
import movingEntity

Class Bullet Extends MovingEntity

	'This constructor differs form the super one because we give the velocity in, which will be constant for all the life of the bullet
	Method New(_leftKey:Int, _rightKey:Int, x:float, y:float, _velocity: Int)
		super.New( x, y )
		self.m_velocity = new Vec2D(_velocity, 0)
		self.m_size		= 8
	End

	Method Update(_gravityWeDontCare:Float)
		
		self.m_velocity.y = 0

		'We put the new position on x/y, then, we cap this position to the screen limit
		self.m_position.x += self.m_velocity.x
		self.m_position.y += self.m_velocity.y

		'if we leave the screen, the bullet is dead
		If self.m_position.x < ( self.m_size / 2 )
			self.m_position.x = DeviceWidth - self.m_size / 2
		End
		If self.m_position.x > ( DeviceWidth - self.m_size / 2 )
			self.m_position.x = self.m_size / 2
		End
	End

	Method Draw()
		SetColor(255, 0, 0)
		DrawRect( self.m_position.x - self.m_size / 2, self.m_position.y - self.m_size / 2, self.m_size, self.m_size)
	End
	

End