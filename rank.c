
/*
void compute_ranks(float *F, int N, int *R, float *avg, float *passing_avg, int *num_passed) {
    int i, j;
    *num_passed = 0;
    *avg = 0.0;
    *passing_avg = 0.0;

    // init ranks
    for (i = 0; i < N; i++) {
        R[i] = 1;
    }

    // compute ranks
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            if (F[i] < F[j]) {
                R[i] += 1;
            }
        }
    }

    // compute averages
    for (i = 0; i < N; i++) {
        *avg += F[i];
        if (F[i] >= 50.0) {
            *passing_avg += F[i];
            *num_passed += 1;
        }
    }

    // check for div by 0
    if (N > 0) *avg /= N;
    if (*num_passed) *passing_avg /= *num_passed;

} // compute_ranks

*/
void compute_ranks(float *F, int N, int *R, float *avg, float *passing_avg, int *num_passed) {
	int i, j;
	*num_passed = 0;
	*avg = 0.0;
	*passing_avg = 0.0;
	float temp;						//variables initialized to decrease memory access
	float temp2;
	float temp3;
	float temp4;
	float temp5;


	int num_passedT = 0;			//pointer variables initialized to decrease memory access
	float avgT = 0.0;
	float passing_avgT = 0.0;

	// init ranks
	for (i = 4; i < N; i = i + 5)   //unroll loop
	{
		R[i] = 1;
		R[i - 1] = 1;
		R[i - 2] = 1;
		R[i - 3] = 1;
		R[i - 4] = 1;
		temp = F[i];				//variables set to decrease memory access
		temp2 = F[i - 1];
		temp3 = F[i - 2];
		temp4 = F[i - 3];
		temp5 = F[i - 4];

		avgT += temp;
		avgT += temp2;
		avgT += temp3;
		avgT += temp4;
		avgT += temp5;


		if (temp >= 50.0) {          //added average calculations to first loop to do both calculations at once
			passing_avgT += temp;
			num_passedT += 1;
		}
		if (temp2 >= 50.0) {
			passing_avgT += temp2;
			num_passedT += 1;
		}
		if (temp3 >= 50.0) {
			passing_avgT += temp3;
			num_passedT += 1;
		}
		if (temp4 >= 50.0) {
			passing_avgT += temp4;
			num_passedT += 1;
		}
		if (temp5 >= 50.0) {
			passing_avgT += temp5;
			num_passedT += 1;
		}

	}
	for (; i <= N; i++) {				 //if unrolled value is odd
		R[i - 1] = 1;

		avgT += F[i - 1];

		temp2 = F[i - 1];

		if (temp2 >= 50.0) {
			passing_avgT += temp2;
			num_passedT += 1;
		}
	}


	// compute ranks
	for (i = 4; i < N; i = i + 5) {         //outer loop unrolled to decrease number of iterations
		for (j = 0; j < N; j++) {
			if (F[i] < F[j]) {
				R[i] += 1;
			}
			if (F[i - 1] < F[j]) {
				R[i - 1] += 1;
			}
			if (F[i - 2] < F[j]) {
				R[i - 2] += 1;
			}
			if (F[i - 3] < F[j]) {
				R[i - 3] += 1;
			}
			if (F[i - 4] < F[j]) {
				R[i - 4] += 1;
			}

		}
	}

	for (; i <= N; i++)               //if unrolled value is odd
	{
		for (j = 0; j < N; j++) {
			if (F[i - 1] < F[j]) {
				R[i - 1] += 1;
			}
		}
	}
	// compute averages

	// check for div by 0
	if (N > 0) avgT /= N;
	if (num_passedT) passing_avgT /= num_passedT;

	*num_passed = num_passedT;                        //set variable calculations back to their pointers
	*avg = avgT;
	*passing_avg = passing_avgT;

} // compute_ranks

