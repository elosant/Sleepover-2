return {
	shakeData = { -- Used as default values in the damped sinusoidal.
		initialAmplitude = 15.2, -- Initial amplitude defines the starting "offset" (multiplied by random noise), the higher the value the larger the effect of the shake.
		decayConstant = 3.7, -- Acts as the coefficient of time (the exponent of e), describes rate of decay, higher the value the lower the effect of "aftershocks".
		angularFrequency = 1.35, -- Multiplicand of pi*time, how "fast" the sinusodial progresses.
	}
}
