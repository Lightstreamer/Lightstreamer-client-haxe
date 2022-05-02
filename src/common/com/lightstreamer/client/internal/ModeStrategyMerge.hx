package com.lightstreamer.client.internal;

import com.lightstreamer.internal.Types;
import com.lightstreamer.client.internal.update.*;

@:build(com.lightstreamer.internal.Macros.synchronizeClass())
class ModeStrategyMerge extends ModeStrategy {

  override public function createItem(itemIdx: Pos): ItemBase {
    return new ItemMerge(itemIdx, subscription, client, m_subId);
  }
}