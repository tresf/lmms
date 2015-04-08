/*
 *  HassanControls.cpp - defination of HassanControls class.
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

#include <QtXml/QDomElement>

#include "HaassanControls.h"
#include "HaassanEffect.h"
#include "Engine.h"
#include "Song.h"



HaassanControls::HaassanControls( HaassanEffect *effect ) :
	EffectControls ( effect ),
	m_effect ( effect ),
	m_lowDelayTimeModel(0.001, 0.000, 0.035, 0.001,  this, tr( "Delay" ) ) ,
	m_lowPolarAmountModel( 0.0, 0.0, 1.0, 0.0001, this, tr( "Polar Amount" ) ),
	m_lowWidthAmountModel( 1.0, 0.0, 5.0, 0.0001, this, tr( "Width" ) ),
	m_hiDelayTimeModel( 0.0, 0.0, 0.035, 0.001, this, tr( "Delay") ),
	m_hiPolarAmountModel( 0.0, 0.0, 1.0, 0.0001, this, tr( "Polar Amount" ) ),
	m_hiWidthAmountModel( 1.0, 0.0, 5.0, 0.0001, this, tr( "Width" ) ),
	m_crossoverFrequencyModel( 80, 20, 20000, 0.001, this, tr( "Crossover Freqncy" ) )
{
	connect( Engine::mixer(), SIGNAL( sampleRateChanged() ), this, SLOT( changedSampleRate() ) );
	m_crossoverFrequencyModel.setScaleLogarithmic( true );
}




void HaassanControls::loadSettings( const QDomElement &_this )
{
	m_lowDelayTimeModel.loadSettings( _this, "LowDelayTimeSamples" );
	m_lowPolarAmountModel.loadSettings( _this, "LowPolarAmount" );
	m_lowWidthAmountModel.loadSettings( _this, "LowWidth" );
	m_crossoverFrequencyModel.loadSettings( _this, "Crossover" );
	m_hiDelayTimeModel.loadSettings( _this, "HiDelayTimeSamples" );
	m_hiPolarAmountModel.loadSettings( _this, "HiPolarAmount" );
	m_hiWidthAmountModel.loadSettings( _this, "HiWidth" );

}




void HaassanControls::saveSettings( QDomDocument &doc, QDomElement &parent )
{
	m_lowDelayTimeModel.saveSettings( doc , parent, "LowDelayTimeSamples" );
	m_lowPolarAmountModel.saveSettings( doc, parent, "LowPolarAmount" );
	m_lowWidthAmountModel.saveSettings( doc, parent, "LowWidth" );
	m_crossoverFrequencyModel.saveSettings( doc, parent, "Crossover" );
	m_hiDelayTimeModel.saveSettings( doc , parent, "HiDelayTimeSamples" );
	m_hiPolarAmountModel.saveSettings( doc, parent, "HiPolarAmount" );
	m_hiWidthAmountModel.saveSettings( doc, parent, "HiWidth" );
}




void HaassanControls::changedSampleRate()
{
	m_effect->changeSampleRate();
}


