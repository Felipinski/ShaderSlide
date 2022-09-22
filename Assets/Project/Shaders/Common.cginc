float4 applyLight(float4 color, float3 normal, float3 viewDir)
{
	float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

	fixed NdotV = max(0, dot(normal, viewDir)) * .5 + .5;
	NdotV = pow(1 - NdotV, 2.5) * 0.5;
	fixed NdotL = dot(normal, lightDirection) * .5 + .5;

	color *= NdotL;

	color.rgb += NdotV;

	return color;
}