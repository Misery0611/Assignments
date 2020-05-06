classdef ObjectPose
	properties
		x = [];
		y = [];
		theta = [];
		capacity = 0;
		poseSize = 0;
	end

	methods

		function aPose = append(aPose, new_x, new_y, new_theta)
			aPose.poseSize = aPose.poseSize + 1;
			if aPose.poseSize > aPose.capacity
				aPose.x = [aPose.x zeros(1, 10)];
				aPose.y = [aPose.y zeros(1, 10)];
				aPose.theta = [aPose.theta zeros(1, 10)];
				aPose.capacity = aPose.capacity + 10;
			end
			aPose.x(aPose.poseSize) = new_x;
			aPose.y(aPose.poseSize) = new_y;
			aPose.theta(aPose.poseSize) = new_theta;
		end

		function aPose = reserve(aPose, cap)
			if cap > aPose.capacity
				aPose.x = [aPose.x zeros(1, cap - aPose.capacity)];
				aPose.y = [aPose.y zeros(1, cap - aPose.capacity)];
				aPose.theta = [aPose.theta zeros(1, cap - aPose.capacity)];
				aPose.capacity = cap;
			end
		end

		function pose = getPose(aPose, index)
			pose = 0;
			if index <= poseSize
				pose = [aPose.x(index) aPose.y(index) aPose.theta(index)];
			end
		end

	end

end