/*
* Copyright (c) 2014-2026, NVIDIA CORPORATION. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a
* copy of this software and associated documentation files (the "Software"),
* to deal in the Software without restriction, including without limitation
* the rights to use, copy, modify, merge, publish, distribute, sublicense,
* and/or sell copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
* DEALINGS IN THE SOFTWARE.
*/

// *INDENT-OFF*
#if TEXTURE_ARRAY
Texture2DMSArray<float4> tex : register( t0 );
#else
Texture2DMS<float4> tex : register( t0 );
#endif
SamplerState samp : register( s0 );

struct PS_IN
{
	float4 posClip	: SV_Position;
	float2 uv		: UV;
};
// *INDENT-ON*

void main(
	PS_IN fragment,
	out float4 o_rgba : SV_Target )
{
	uint width, height, elements, sampleCount;
#if TEXTURE_ARRAY
	tex.GetDimensions( width, height, elements, sampleCount );
	// third component is hardcoded to array index 0 for now
	int3 texCoord = int3( fragment.uv.x * width, fragment.uv.y * height, 0 );
#else
	tex.GetDimensions( width, height, sampleCount );
	int2 texCoord = int2( fragment.uv.x * width, fragment.uv.y * height );
#endif

	// Accumulate the color of every sample at this pixel location
	float4 combinedColor = float4( 0, 0, 0, 0 );
	[loop]
	for( uint i = 0; i < sampleCount; ++i )
	{
		combinedColor += tex.Load( texCoord, i );
	}

	// Average the result
	o_rgba = combinedColor / (float)sampleCount;
}
