/*
 * HaassanEffect.cpp - defination of HaassanEffect class.
 *
 * Copyright (c) 2015 David French <dave/dot/french3/at/googlemail/dot/com>
 *
 * This file is part of LMMS - http://lmms.io
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program (see COPYING); if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 */

#include "HaassanEffect.h"
#include "Engine.h"
#include "embed.cpp"
#include "lmms_math.h"

extern "C"
{

Plugin::Descriptor PLUGIN_EXPORT haassan_plugin_descriptor =
{
	STRINGIFY( PLUGIN_NAME ),
	"Haassan",
	QT_TRANSLATE_NOOP( "pluginBrowser", "A native Stereo Expander plugin" ),
	"Dave French <contact/dot/dave/dot/french3/at/googlemail/dot/com>",
	0x0100,
	Plugin::Effect,
	new PluginPixmapLoader( "logo" ),
	NULL,
	NULL
} ;




HaassanEffect::HaassanEffect( Model *parent, const Plugin::Descriptor::SubPluginFeatures::Key *key ) :
	Effect( &haassan_plugin_descriptor, parent, key ),
	m_haassanControls( this ),
	m_hiPass( Engine::mixer()->processingSampleRate() ),
	m_lowPass( Engine::mixer()->processingSampleRate() )
{
	m_lowDelay = new MonoDelay( 1, Engine::mixer()->processingSampleRate() );
	m_hiDelay = new MonoDelay( 1, Engine::mixer()->processingSampleRate() );
}




HaassanEffect::~HaassanEffect()
{
	if(m_lowDelay )
	{
		delete m_lowDelay;
	}
	if( m_hiDelay )
	{
		delete m_hiDelay;
	}

}




bool HaassanEffect::processAudioBuffer( sampleFrame *buf, const fpp_t frames )
{
	if( !isEnabled() || !isRunning () )
	{
		return( false );
	}
	double outSum = 0.0;
	const float d = dryLevel();
	const float w = wetLevel();
	const float lowLength = m_haassanControls.m_lowDelayTimeModel.value() * Engine::mixer()->processingSampleRate();
	const float hiLength = m_haassanControls.m_hiDelayTimeModel.value() * Engine::mixer()->processingSampleRate();
	sample_t dryS[2];
	//set crossover frequiency.
	m_lowPass.setLowpass( m_haassanControls.m_crossoverFrequencyModel.value() );
	m_hiPass.setHighpass( m_haassanControls.m_crossoverFrequencyModel.value() );

	sampleFrame lowSample;
	sampleFrame hiSample;

	for( fpp_t f = 0; f < frames; ++f )
	{
		dryS[0] = buf[f][0];
		dryS[1] = buf[f][1];
		//split bands
		lowSample[0] = m_lowPass.update( buf[f][0], 0 );
		lowSample[1] = m_lowPass.update( buf[f][1], 1 );
		hiSample[0] = m_hiPass.update( buf[f][0], 0);
		hiSample[1] = m_hiPass.update( buf[f][1], 1);

		//process low band

		//HAAS
		m_lowDelay->setLength( ( float )lowLength );
		m_lowDelay->tick( &lowSample[0] );
		//POLAR
		sample_t lowTemp = lowSample[0];
		lowSample[0] += lowSample[1] * m_haassanControls.m_lowPolarAmountModel.value();
		lowSample[1] += lowTemp * m_haassanControls.m_lowPolarAmountModel.value();
		lowSample[0] *=  1 - m_haassanControls.m_lowPolarAmountModel.value()  * 0.25;
		lowSample[1] *=  1 - m_haassanControls.m_lowPolarAmountModel.value()  * 0.25;

		//Stereo Width Control (Obtained Via Transfromation Matrix)
		//Michael Gruhn
		//http://www.musicdsp.org/showArchiveComment.php?ArchiveID=256

		float lowTmp = 1/max( 1 + m_haassanControls.m_lowWidthAmountModel.value(), 2.0f );
		float lowCoef_M = 1 * lowTmp;
		float lowCoef_S = m_haassanControls.m_lowWidthAmountModel.value() * lowTmp;
		float lowM = ( lowSample[0] + lowSample[1] ) * lowCoef_M;
		float lowS = ( lowSample[1] -lowSample[0] ) * lowCoef_S;
		lowSample[0] = lowM - lowS;
		lowSample[1] = lowM + lowS;

		//process hi band

		//HAAS
		m_hiDelay->setLength( ( float )hiLength );
		m_hiDelay->tick( &hiSample[0] );
		//POLAR
		sample_t hiTemp = hiSample[0];
		hiSample[0] += hiSample[1] * m_haassanControls.m_hiPolarAmountModel.value();
		hiSample[1] += hiTemp * m_haassanControls.m_hiPolarAmountModel.value();
		hiSample[0] *=  1 - m_haassanControls.m_hiPolarAmountModel.value()  * 0.25;
		hiSample[1] *=  1 - m_haassanControls.m_hiPolarAmountModel.value()  * 0.25;

		//Stereo Width Control (Obtained Via Transfromation Matrix)
		//Michael Gruhn
		//http://www.musicdsp.org/showArchiveComment.php?ArchiveID=256

		float hiTmp = 1/max( 1 + m_haassanControls.m_hiWidthAmountModel.value(), 2.0f );
		float hiCoef_M = 1 * hiTmp;
		float hiCoef_S = m_haassanControls.m_hiWidthAmountModel.value() * hiTmp;
		float hiM = ( hiSample[0] + hiSample[1] ) * hiCoef_M;
		float hiS = ( hiSample[1] - hiSample[0] ) * hiCoef_S;
		hiSample[0] = hiM - hiS;
		hiSample[1] = hiM + hiS;




		//mix bands
		buf[f][0] = lowSample[0] + hiSample[0];
		buf[f][1] = lowSample[1] + hiSample[1];


		//wet dry mix
		buf[f][0] = ( d * dryS[0] ) + ( w * buf[f][0] );
		buf[f][1] = ( d * dryS[1] ) + ( w * buf[f][1] );
		outSum += buf[f][0]*buf[f][0] + buf[f][1]*buf[f][1];
	}
	checkGate( outSum / frames );
	return isRunning();
}




void HaassanEffect::changeSampleRate()
{
	m_lowDelay->setSampleRate( Engine::mixer()->processingSampleRate() );
	m_lowPass.setSampleRate( Engine::mixer()->processingSampleRate() );
	m_hiPass.setSampleRate( Engine::mixer()->processingSampleRate() );
}



extern "C"
{

//needed for getting plugin out of shared lib
Plugin * PLUGIN_EXPORT lmms_plugin_main( Model* parent, void* data )
{
	return new HaassanEffect( parent , static_cast<const Plugin::Descriptor::SubPluginFeatures::Key *>( data ) );
}

}}
