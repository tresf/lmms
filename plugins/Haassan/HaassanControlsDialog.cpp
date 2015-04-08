/*
 * HaassanControlsDialog.cpp - defination of HaassanControlsDialog class.
 *
 * Copyright (c) 2014 David French <dave/dot/french3/at/googlemail/dot/com>
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

#include "HaassanControlsDialog.h"
#include "HaassanControls.h"
#include "embed.h"
#include "LedCheckbox.h"
#include "TempoSyncKnob.h"




HassanControlsDialog::HassanControlsDialog( HaassanControls *controls ) :
	EffectControlDialog( controls )
{
	setAutoFillBackground( true );
	QPalette pal;
	pal.setBrush( backgroundRole(), PLUGIN_NAME::getIconPixmap( "artwork" ) );
	setPalette( pal );
	setFixedSize( 130, 130 );

	Knob* lowDelayKnob = new Knob( knobBright_26, this );
	lowDelayKnob->move( 20,90 );
	lowDelayKnob->setVolumeKnob( false );
	lowDelayKnob->setModel( &controls->m_lowDelayTimeModel );
	lowDelayKnob->setLabel( tr( "Delay" ) );
	lowDelayKnob->setHintText( tr( "Delay Time:" ) + " ", "" );

	Knob* lowPolarKnob = new Knob( knobBright_26, this );
	lowPolarKnob->move( 60, 90 );
	lowPolarKnob->setVolumeKnob( false );
	lowPolarKnob->setModel( &controls->m_lowPolarAmountModel );
	lowPolarKnob->setLabel( tr( "Polar" ) );
	lowPolarKnob->setHintText( tr( "Polar Amount" ) + " ", "");

	Knob* lowWidthKnob = new Knob( knobBright_26, this );
	lowWidthKnob->move( 100, 90 );
	lowWidthKnob->setVolumeKnob( false );
	lowWidthKnob->setModel( &controls->m_lowWidthAmountModel );
	lowWidthKnob->setLabel( tr( "Width" ) );
	lowWidthKnob->setHintText( tr( "Width Amount" ) + " ", "");

	Knob* crossoverKnob = new Knob( knobBright_26, this );
	crossoverKnob->move( 60, 50 );
	crossoverKnob->setVolumeKnob( false );
	crossoverKnob->setModel( &controls->m_crossoverFrequencyModel );
	crossoverKnob->setLabel( tr( "CrossOver" ) );
	crossoverKnob->setHintText( tr( "Crossover Frequency" ) + " ", "");

	Knob* hiDelayKnob = new Knob( knobBright_26, this );
	hiDelayKnob->move( 20,10 );
	hiDelayKnob->setVolumeKnob( false );
	hiDelayKnob->setModel( &controls->m_hiDelayTimeModel );
	hiDelayKnob->setLabel( tr( "Delay" ) );
	hiDelayKnob->setHintText( tr( "Delay Time:" ) + " ", "" );

	Knob* hiPolarKnob = new Knob( knobBright_26, this );
	hiPolarKnob->move( 60, 10 );
	hiPolarKnob->setVolumeKnob( false );
	hiPolarKnob->setModel( &controls->m_hiPolarAmountModel );
	hiPolarKnob->setLabel( tr( "Polar" ) );
	hiPolarKnob->setHintText( tr( "Polar Amount" ) + " ", "");

	Knob* hiWidthKnob = new Knob( knobBright_26, this );
	hiWidthKnob->move( 100, 10 );
	hiWidthKnob->setVolumeKnob( false );
	hiWidthKnob->setModel( &controls->m_hiWidthAmountModel );
	hiWidthKnob->setLabel( tr( "Width" ) );
	hiWidthKnob->setHintText( tr( "Width Amount" ) + " ", "");

}
