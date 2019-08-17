return {
	shakeData = { -- Used as default values in the damped sinusoidal.
		-- Initial amplitude defines the starting "offset" (multiplied by random noise), the higher the value the larger the effect of the shake.
		initialAmplitude = 1,
		-- Acts as the coefficient of time (the exponent of e), describes rate of decay, higher the value the lower the effect of "aftershocks".
		decayConstant = 1,
		-- Multiplicand of pi*time, how "fast" the sinusodial progresses.
		angularFrequency = 1,
	}
}
