close all;
dt = 2.5;
l = 30;
r = pi / 6;

x_init = 0;
y_init = 0;
theta_init = 0;

w_right = [14];
w_left  = [11];

idle_period = [32];

total_poses = 1;
for i = 1 : length(idle_period)
	total_poses = total_poses + idle_period(i);
end

% Init Theory pose, Real pose and EKF pose
theory_pose = ObjectPose;
theory_pose = reserve(theory_pose, total_poses);
theory_pose = append(theory_pose, x_init, y_init, theta_init);

real_pose = ObjectPose;
real_pose = reserve(real_pose, total_poses);
real_pose = append(real_pose, x_init, y_init, theta_init);

EKF_pose = ObjectPose;
EKF_pose = reserve(EKF_pose, total_poses);
EKF_pose = append(EKF_pose, x_init, y_init, theta_init);

% Real system noise standard deviation
systeam_noise_std = [0.6 0.6];
% Real measurement noise standard deviation
measurement_noise_std = [5 5 0.08];

% Init variance is 0
P = zeros(3);

k = 1;
for i = 1 : length(idle_period)

	% Theory translation velocity and angle velocity
	velocity = (w_right(i) + w_left(i)) * r / 2;
    w_new 	 = (w_right(i) - w_left(i)) * r / l;

    % Real translation velocity and angle velocity
    real_wR = w_right(i) + random('Normal', 0, systeam_noise_std(1));
    real_wL = w_left(i)  + random('Normal', 0, systeam_noise_std(2));
    real_velocity = (real_wR + real_wL) * r / 2;
    real_w_new 	  = (real_wR - real_wL) * r / l;

    for j = 1 : idle_period(i)

    	% Evaluate Theory pose
        new_theta = theory_pose.theta(k) + w_new * dt;
        new_x = theory_pose.x(k) + velocity * dt * cos( (theory_pose.theta(k) + new_theta) / 2);
        new_y = theory_pose.y(k) + velocity * dt * sin( (theory_pose.theta(k) + new_theta) / 2);
        theory_pose = append(theory_pose, new_x, new_y, new_theta);

        % Evaluate Real pose
        new_theta = real_pose.theta(k) + real_w_new * dt;
        new_x = real_pose.x(k) + real_velocity * dt * cos( (real_pose.theta(k) + new_theta) / 2);
        new_y = real_pose.y(k) + real_velocity * dt * sin( (real_pose.theta(k) + new_theta) / 2);
        real_pose = append(real_pose, new_x, new_y, new_theta);

        % Measurement pose
        measure_x = real_pose.x(k + 1) + random('Normal', 0, measurement_noise_std(1));
        measure_y = real_pose.y(k + 1) + random('Normal', 0, measurement_noise_std(2));
        measure_theta = real_pose.theta(k + 1) + random('Normal', 0, measurement_noise_std(3));
        measure_pose = [measure_x measure_y measure_theta];

        % Prior estimation (Prediction)
        new_theta = EKF_pose.theta(k) + w_new * dt;
        new_x = EKF_pose.x(k) + velocity * dt * cos( (EKF_pose.theta(k) + new_theta) / 2);
        new_y = EKF_pose.y(k) + velocity * dt * sin( (EKF_pose.theta(k) + new_theta) / 2);
        prior_est = [new_x new_y new_theta];

        % Jacobian matrix of partial derivatives of f with respect to Pose
        A = [1 0 -dt * velocity * sin(EKF_pose.theta(k));
        	 1 0  dt * velocity * cos(EKF_pose.theta(k));
        	 0 0 1];
       	% Jacobian matrix of partial derivatives of f with respect to w
        W = dt * r / 2 * [cos(EKF_pose.theta(k)) cos(EKF_pose.theta(k));
        				  sin(EKF_pose.theta(k)) sin(EKF_pose.theta(k));
        				  2 / l 				2 / l];
       	% System noise covariance matrix
        Q = [1 * w_right(i) ^ 2 	0;
	 		 0						1 * w_left(i) ^ 2];
	 	% Measurement noise covariance matrix
	 	R = [10		0		0;
			 0		10 		0;
			 0		0		0.01];

		% Prediction
        prior_P = A * P * A' + W * Q * W';

        % Update
        K =  prior_P * inv(prior_P + R);
        pos_est = prior_est' + K * (measure_pose - prior_est)';
        P = prior_P - K * prior_P;

        EKF_pose = append(EKF_pose, pos_est(1), pos_est(2), pos_est(3));

        k = k + 1;
    end
end

plot(theory_pose.x, theory_pose.y);
hold on;
plot(real_pose.x, real_pose.y);
plot(EKF_pose.x, EKF_pose.y);
legend('Theory', 'Real', 'EKF estimation');
axis equal;