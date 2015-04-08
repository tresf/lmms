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
	setFixedSize( 200, 75 );

	Knob* delayKnob = new Knob( knobBright_26, this );
	delayKnob->move( 20,10 );
	delayKnob->setVolumeKnob( false );
	delayKnob->setModel( &controls->m_delayTimeModel );
	delayKnob->setLabel( tr( "Delay" ) );
	delayKnob->setHintText( tr( "Delay Time:" ) + " ", "" );

	Knob* polarKnob = new Knob( knobBright_26, this );
	polarKnob->move( 60, 10 );
	polarKnob->setVolumeKnob( false );
	polarKnob->setModel( &controls->m_polarAmountModel );
	polarKnob->setLabel( tr( "Polar" ) );
	polarKnob->setHintText( tr( "Polar Amount" ) + " ", "");

	Knob* widthKnob = new Knob( knobBright_26, this );
	widthKnob->move( 100, 10 );
	widthKnob->setVolumeKnob( false );
	widthKnob->setModel( &controls->m_widthAmountModel );
	widthKnob->setLabel( tr( "Width" ) );
	widthKnob->setHintText( tr( "Width Amount" ) + " ", "");
}
