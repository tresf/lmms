/*
 * flangercontrols.h - defination of StereoDelay class.
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

#ifndef HASSANCONTROLS_H
#define HASSANCONTROLS_H

#include "EffectControls.h"
#include "Knob.h"
#include "HaassanControlsDialog.h"


class HaassanEffect;

class HaassanControls : public EffectControls
{
	Q_OBJECT
public:
	HaassanControls( HaassanEffect* effect );
	virtual ~HaassanControls()
	{
	}
	virtual void saveSettings ( QDomDocument& doc, QDomElement& parent );
	virtual void loadSettings ( const QDomElement &_this );
	inline virtual QString nodeName() const
	{
		return "Flanger";
	}
	virtual int controlCount()
	{
		return 5;
	}
	virtual EffectControlDialog* createView()
	{
		return new HassanControlsDialog( this );
	}

private slots:
	void changedSampleRate();

private:
	HaassanEffect* m_effect;
	FloatModel m_delayTimeModel;
	FloatModel m_polarAmountModel;


	friend class HassanControlsDialog;
	friend class HaassanEffect;

};

#endif // HASSANCONTROLS_H
