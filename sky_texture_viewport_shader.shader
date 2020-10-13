shader_type canvas_item;

float bias(float t, float b){
	return ( t / ((((1.0/b) - 2.0) *(1.0 - t)) + 1.0 ));
}

float gain(float t, float g){
	if(t < 0.5){
		return bias(t * 2.0, g)/2.0;
	} else{
		return bias( t * 2.0 - 1.0, 1.0 - g )/2.0 + 0.5;
	}
		
}

void fragment() {
	float c = mix(0.01, 0.05, gain(UV.y, 0.05));
    COLOR = vec4(c, c, c, 1.0);
}

