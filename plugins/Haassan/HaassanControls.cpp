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
	m_delayTimeModel(0.001, 0.0001, 0.035, 0.001,  this, tr( "Delay Samples" ) ) ,
	m_polarAmountModel( 0.0, 0.0, 1.0, 0.0001, this, tr( "Polar Amount" ) )
{
    connect( Engine::mixer(), SIGNAL( sampleRateChanged() ), this, SLOT( changedSampleRate() ) );
}




void HaassanControls::loadSettings( const QDomElement &_this )
{
    m_delayTimeModel.loadSettings( _this, "DelayTimeSamples" );
	m_polarAmountModel.loadSettings( _this, "PolarAmount" );

}




void HaassanControls::saveSettings( QDomDocument &doc, QDomElement &parent )
{
    m_delayTimeModel.saveSettings( doc , parent, "DelayTimeSamples" );
	m_polarAmountModel.saveSettings( doc, parent, "PolarAmount" );
}




void HaassanControls::changedSampleRate()
{
    m_effect->changeSampleRate();
}


