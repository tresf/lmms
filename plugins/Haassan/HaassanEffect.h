/*
 * flangereffect.h - defination of FlangerEffect class.
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


#ifndef FLANGEREFFECT_H
#define FLANGEREFFECT_H

#include "Effect.h"
#include "HaassanControls.h"

#include "../flanger/monodelay.h"



class HaassanEffect : public Effect
{
public:
	HaassanEffect( Model* parent , const Descriptor::SubPluginFeatures::Key* key );
	virtual ~HaassanEffect();
	virtual bool processAudioBuffer( sampleFrame *buf, const fpp_t frames );
	virtual EffectControls* controls()
	{
		return &m_haassanControls;
	}
	void changeSampleRate();

private:
	HaassanControls m_haassanControls;
	MonoDelay* m_delay;


};

#endif // FLANGEREFFECT_H
