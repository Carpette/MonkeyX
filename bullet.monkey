import utils

Class Bullet Extends MovingEntity

	Method Update(_gravity:Float)
		
		self.m_velocity.x = 40
		self.m_velocity.y = 0

		'We put the new position on x/y, then, we cap this position to the screen limit
		self.m_position.x += self.m_velocity.x
		self.m_position.y += self.m_velocity.y
	End
	

End