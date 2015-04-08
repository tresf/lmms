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
	m_haassanControls( this )
{
	m_delay = new MonoDelay( 1, Engine::mixer()->processingSampleRate() );
}




HaassanEffect::~HaassanEffect()
{
	if(m_delay )
	{
		delete m_delay;
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
	const float length = m_haassanControls.m_delayTimeModel.value() * Engine::mixer()->processingSampleRate();
	sample_t dryS[2];
	for( fpp_t f = 0; f < frames; ++f )
	{
		dryS[0] = buf[f][0];
		dryS[1] = buf[f][1];
		//HAAS
		m_delay->setLength( ( float )length );
		m_delay->tick( &buf[f][0] );
		//POLAR
		sample_t temp = buf[f][0];
		buf[f][0] += buf[f][1] * m_haassanControls.m_polarAmountModel.value();
		buf[f][1] += temp * m_haassanControls.m_polarAmountModel.value();
		buf[f][0] *=  1 - m_haassanControls.m_polarAmountModel.value()  * 0.25;
		buf[f][1] *=  1 - m_haassanControls.m_polarAmountModel.value()  * 0.25;

		//Stereo Width Control (Obtained Via Transfromation Matrix)
		//Michael Gruhn
		//http://www.musicdsp.org/showArchiveComment.php?ArchiveID=256

		float tmp = 1/max( 1 + m_haassanControls.m_widthAmountModel.value(), 2.0f );
		float coef_M = 1 * tmp;
		float coef_S = m_haassanControls.m_widthAmountModel.value() * tmp;

		float m = ( buf[f][0] + buf[f][1] ) * coef_M;
		float s = ( buf[f][1] - buf[f][0] ) * coef_S;

		buf[f][0] = m - s;
		buf[f][1] = m + s;


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
	m_delay->setSampleRate( Engine::mixer()->processingSampleRate() );
}



extern "C"
{

//needed for getting plugin out of shared lib
Plugin * PLUGIN_EXPORT lmms_plugin_main( Model* parent, void* data )
{
	return new HaassanEffect( parent , static_cast<const Plugin::Descriptor::SubPluginFeatures::Key *>( data ) );
}

}}
