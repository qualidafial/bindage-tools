package com.overstock.bindme.impl {
import com.overstock.bindme.BindGroup;
import com.overstock.bindme.IPipelineStep;
import com.overstock.bindme.util.applyArgs;

public class GroupStep implements IPipelineStep {

  private var group:BindGroup;

  public function GroupStep( group:BindGroup ) {
    this.group = group;
  }

  public function wrapStep( nextStep:Function ):Function {
    return applyArgs(group.callExclusively, nextStep);
  }

}

}
