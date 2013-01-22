/* -*-	Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */
/*
 * Copyright (c) 1997 Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the Computer Systems
 *	Engineering Group at Lawrence Berkeley Laboratory.
 * 4. Neither the name of the University nor of the Laboratory may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * Ported from CMU/Monarch's code, nov'98 -Padma.
 *
 * $Header: /cvsroot/nsnam/ns-2/dsdv/dsdv.cc,v 1.26 2006/02/21 15:20:18 mahrenho Exp $
 */

extern "C" {
#include <stdarg.h>
#include <float.h>
}

#include "dsdv.h"
#include "priqueue.h"

#include <random.h>

#include <cmu-trace.h>
#include <address.h>
#include <mobilenode.h>

//IDRM_SH
//#include <common/mobilenode.h>
//IDRM_SH

//IDRM_SH
#define CURRENT_TIME    Scheduler::instance().clock()
#include <idrm/idrm.h>

int IDRM_SH = 0;			//debug mode set
int DSDV_DEBUG =0;

int IDRM_SH_DEMO_DSDV =0;

int total_n_control_pkt_dsdv=0;
int total_s_control_pkt_dsdv=0;
//IDRM_SH	
	
#define DSDV_STARTUP_JITTER 2.0	// secs to jitter start of periodic activity from
				// when start-dsr msg sent to agent
#define DSDV_ALMOST_NOW     0.1 // jitter used for events that should be effectively
				// instantaneous but are jittered to prevent
				// synchronization
#define DSDV_BROADCAST_JITTER 0.01 // jitter for all broadcast packets
#define DSDV_MIN_TUP_PERIOD 1.0 // minimum time between triggered updates
#define IP_DEF_TTL   32 // default TTTL

bool *gateway_list	= NULL;
bool *gateway_list2 = NULL;
bool *gateway_list3 = NULL;
bool *gateway_list4 = NULL;

//0827
int dsdv_pkt_drop=0;
int dsdv_pkt_not_drop=0;

int idrm_pkt_drop=0;
int idrm_pkt_not_drop=0;

int idrm_gt_drop=0;
int idrm_gt_not_drop=0;
//0827

#undef TRIGGER_UPDATE_ON_FRESH_SEQNUM
//#define TRIGGER_UPDATE_ON_FRESH_SEQNUM
/* should the receipt of a fresh (newer) sequence number cause us
   to send a triggered update?  If undef'd, we'll only trigger on
   routing metric changes */

// Returns a random number between 0 and max
static inline double 
jitter (double max, int be_random_)
{
  return (be_random_ ? Random::uniform(max) : 0);
}

void DSDV_Agent::
trace (char *fmt,...)
{
  va_list ap;

  if (!tracetarget)
    return;

  va_start (ap, fmt);
  vsprintf (tracetarget->pt_->buffer (), fmt, ap);
  tracetarget->pt_->dump ();
  va_end (ap);
}

void 
DSDV_Agent::tracepkt (Packet * p, double now, int me, const char *type)
{
  char buf[1024];

  unsigned char *walk = p->accessdata ();

  int ct = *(walk++);
  int seq, dst, met;

  snprintf (buf, 1024, "V%s %.5f _%d_ [%d]:", type, now, me, ct);
  while (ct--)
    {
      dst = *(walk++);
      dst = dst << 8 | *(walk++);
      dst = dst << 8 | *(walk++);
      dst = dst << 8 | *(walk++);
      met = *(walk++);
      seq = *(walk++);
      seq = seq << 8 | *(walk++);
      seq = seq << 8 | *(walk++);
      seq = seq << 8 | *(walk++);
      snprintf (buf, 1024, "%s (%d,%d,%d)", buf, dst, met, seq);
    }
  // Now do trigger handling.
  //trace("VTU %.5f %d", now, me);
  if (verbose_)
    trace ("%s", buf);
}

// Prints out an rtable element.
void
DSDV_Agent::output_rte(const char *prefix, rtable_ent * prte, DSDV_Agent * a)
{
  a->trace("DFU: deimplemented");
  printf("DFU: deimplemented");

  prte = 0;
  prefix = 0;
#if 0
  printf ("%s%d %d %d %d %f %f %f %f 0x%08x\n",
	  prefix, prte->dst, prte->hop, prte->metric, prte->seqnum,
	  prte->udtime, prte->new_seqnum_at, prte->wst, prte->changed_at,
	  (unsigned int) prte->timeout_event);
  a->trace ("VTE %.5f %d %d %d %d %f %f %f %f 0x%08x",
          Scheduler::instance ().clock (), prte->dst, prte->hop, prte->metric,
	  prte->seqnum, prte->udtime, prte->new_seqnum_at, prte->wst, prte->changed_at,
	    prte->timeout_event);
#endif
}

class DSDVTriggerHandler : public Handler {
  public:
    DSDVTriggerHandler(DSDV_Agent *a_) { a = a_; }
    virtual void handle(Event *e);
  private:
    DSDV_Agent *a;
};


void
DSDVTriggerHandler::handle(Event *e)
 // send a triggered update (or a full update if one's needed)
{
	//DEBUG
	//printf("(%d)-->triggered update with e=%x\n", a->myaddr_,e); 

  Scheduler & s = Scheduler::instance ();
  Time now = s.clock ();
  rtable_ent *prte;
  int update_type;	 // we want periodic (=1) or triggered (=0) update?
  Time next_possible = a->lasttup_ + DSDV_MIN_TUP_PERIOD;

  for (a->table_->InitLoop(); (prte = a->table_->NextLoop());)
	  if (prte->trigger_event == e) break;

  assert(prte && prte->trigger_event == e);

  if (now < next_possible)
    {
	    //DEBUG
	    //printf("(%d)..Re-scheduling triggered update\n",a->myaddr_);
			//printf("0902 re-scheduling event NodeId: %d, eventId: %d, at %lf\n", a->myaddr_, e->uid_, CURRENT_TIME);

      s.schedule(a->trigger_handler, e, next_possible - now);
      a->cancelTriggersBefore(next_possible);
      return;
    }

  update_type = 0;
  Packet * p = a->makeUpdate(/*in-out*/update_type);
      
  if (p != NULL) 
    {	  
      if (update_type == 1)
	{ // we got a periodic update, though we only asked for triggered
	  // cancel and reschedule periodic update
	  s.cancel(a->periodic_callback_);
	  //DEBUG
	  //printf("we got a periodic update, though asked for trigg\n");
	  s.schedule (a->helper_, a->periodic_callback_, 
		      a->perup_ * (0.75 + jitter (0.25, a->be_random_)));
	  if (a->verbose_) a->tracepkt (p, now, a->myaddr_, "PU");	  
	}
      else
	{
	  if (a->verbose_) a->tracepkt (p, now, a->myaddr_, "TU");	  
	}
      assert (!HDR_CMN (p)->xmit_failure_);	// DEBUG 0x2	  
      
      //IDRM_SH : count the control msg.. 0806
			struct hdr_cmn *ch = HDR_CMN(p);
      total_n_control_pkt_dsdv ++;
			total_s_control_pkt_dsdv += ch->size();
			//IDRM_SH

      s.schedule (a->target_, p, jitter(DSDV_BROADCAST_JITTER, a->be_random_));
      
      a->lasttup_ = now; // even if we got a full update, it still counts
      // for our last triggered update time
    }
  
  // free this event
  for (a->table_->InitLoop (); (prte = a->table_->NextLoop ());)
    if (prte->trigger_event && prte->trigger_event == e)
      {
	prte->trigger_event = 0;

	//printf("0902 deleting event NodeId: %d, eventId: %d, at %lf\n", a->myaddr_, e->uid_, CURRENT_TIME);

	delete e;
      }
}

void
DSDV_Agent::cancelTriggersBefore(Time t)
  // Cancel any triggered events scheduled to take place *before* time
  // t (exclusive)
{
  rtable_ent *prte;
  Scheduler & s = Scheduler::instance ();

  for (table_->InitLoop (); (prte = table_->NextLoop ());)
    if (prte->trigger_event && prte->trigger_event->time_ < t)
      {
	      //DEBUG
	      //printf("(%d) cancel event %x\n",myaddr_,prte->trigger_event);
	s.cancel(prte->trigger_event);
	delete prte->trigger_event;
	prte->trigger_event = 0;
      }
}

void
DSDV_Agent::needTriggeredUpdate(rtable_ent *prte, Time t)
  // if no triggered update already pending, make one so
{
  Scheduler & s = Scheduler::instance();
  Time now = Scheduler::instance().clock();

  assert(t >= now);

  if (prte->trigger_event) 
    s.cancel(prte->trigger_event);
  else
    prte->trigger_event = new Event;
  //DEBUG
  //printf("(%d)..scheduling trigger-update with event %x\n",myaddr_,prte->trigger_event);
  s.schedule(trigger_handler, prte->trigger_event, t - now);
}

void
DSDV_Agent::helper_callback (Event * e)
{
  Scheduler & s = Scheduler::instance ();
  double now = s.clock ();
  rtable_ent *prte;
  rtable_ent *pr2;
  int update_type;	 // we want periodic (=1) or triggered (=0) update?
  //DEBUG
  //printf("Triggered handler on 0x%08x\n", e);

  // Check for periodic callback
  if (periodic_callback_ && e == periodic_callback_)
    {
      update_type = 1;
      Packet *p = makeUpdate(/*in-out*/update_type);
      if (verbose_)
	{
	  trace ("VPC %.5f _%d_", now, myaddr_);
	  tracepkt (p, now, myaddr_, "PU");
	}

      
      if (p) {
	      assert (!HDR_CMN (p)->xmit_failure_);	// DEBUG 0x2
	      // send out update packet jitter to avoid sync
	      //DEBUG
	      //printf("(%d)..sendout update pkt (periodic=%d)\n",myaddr_,update_type);
	      
        //IDRM_SH: count the control msg.. 0806
				struct hdr_cmn *ch = HDR_CMN(p);
	      total_n_control_pkt_dsdv ++;
				total_s_control_pkt_dsdv += ch->size();
				//IDRM_SH

	      s.schedule (target_, p, jitter(DSDV_BROADCAST_JITTER, be_random_));
      }
      
      // put the periodic update sending callback back onto the 
      // the scheduler queue for next time....
      s.schedule (helper_, periodic_callback_, 
		  perup_ * (0.75 + jitter (0.25, be_random_)));

      // this will take the place of any planned triggered updates
      lasttup_ = now;
      return;
    }

  // Check for timeout
  // If it was a timeout, fix the routing table.
  for (table_->InitLoop (); (prte = table_->NextLoop ());)
    if (prte->timeout_event && (prte->timeout_event == e))
      break;

  // If it was a timeout, prte will be non-NULL
  // Note that in the if we don't touch the changed_at time, so that when
  // wst is computed, it doesn't consider the infinte metric the best
  // one at that sequence number.
  if (prte)
	  {
      if (verbose_)
	{
	  trace ("VTO %.5f _%d_ %d->%d", now, myaddr_, myaddr_, prte->dst);
	  /*	  trace ("VTO %.5f _%d_ trg_sch %x on sched %x time %f", now, myaddr_, 
		 trigupd_scheduled, 
		 trigupd_scheduled ? s.lookup(trigupd_scheduled->uid_) : 0,
		 trigupd_scheduled ? trigupd_scheduled->time_ : 0); */
	}
      
      for (table_->InitLoop (); (pr2 = table_->NextLoop ()); )
	{
	  if (pr2->hop == prte->dst && pr2->metric != BIG)
	    {
	      if (verbose_)
		trace ("VTO %.5f _%d_ marking %d", now, myaddr_, pr2->dst);
	      pr2->metric = BIG;
	      pr2->advertise_ok_at = now;
	      pr2->advert_metric = true;
	      pr2->advert_seqnum = true;
	      pr2->seqnum++;
	      // And we have routing info to propogate.
	      //DEBUG
	      //printf("(%d)..we have routing info to propagate..trigger update for dst %d\n",myaddr_,pr2->dst);
	      needTriggeredUpdate(pr2, now);
	    }
	}

      // OK the timeout expired, so we'll free it. No dangling pointers.
      prte->timeout_event = 0;    
    }
  else 
    { // unknown event on  queue
      fprintf(stderr,"DFU: unknown queue event\n");
     abort();
    }

  if (e){
		//printf("0902 heredeleting event NodeId: %d, eventId: %d, at %lf\n", myaddr_, e->uid_, CURRENT_TIME);
    delete e;
  }
}

void
DSDV_Agent::lost_link (Packet *p)
{
  hdr_cmn *hdrc = HDR_CMN (p);
  rtable_ent *prte = table_->GetEntry (hdrc->next_hop_);

  if(use_mac_ == 0) {
          drop(p, DROP_RTR_MAC_CALLBACK);
          return;
  }

  //DEBUG
  //printf("(%d)..Lost link..\n",myaddr_);
  if (verbose_ && hdrc->addr_type_ == NS_AF_INET)
    trace("VLL %.8f %d->%d lost at %d",
    Scheduler::instance().clock(),
	   hdr_ip::access(p)->saddr(), hdr_ip::access(p)->daddr(),
	   myaddr_);

  if (!use_mac_ || !prte || hdrc->addr_type_ != NS_AF_INET)
    return;

  if (verbose_)
    trace ("VLP %.5f %d:%d->%d:%d lost at %d [hop %d]",
  Scheduler::instance ().clock (),
	   hdr_ip::access (p)->saddr(),
	   hdr_ip::access (p)->sport(),
	   hdr_ip::access (p)->daddr(),
	   hdr_ip::access (p)->dport(),
	   myaddr_, prte->dst);

  if (prte->timeout_event)
    {
      Scheduler::instance ().cancel (prte->timeout_event);
      helper_callback (prte->timeout_event);
    }
  else if (prte->metric != BIG)
    {
      assert(prte->timeout_event == 0);
      prte->timeout_event = new Event ();
      helper_callback (prte->timeout_event);
    }

  // Queue these packets up...
  recv(p, 0);

#if 0
  while (p2 = ((PriQueue *) target_)->filter (prte->dst))
    {
      if (verbose_)
      trace ("VRS %.5f %d:%d->%d:%d lost at %d", Scheduler::instance ().clock (),
	       hdr_ip::access (p2)->saddr(),
	       hdr_ip::access (p2)->sport(),
	       hdr_ip::access (p2)->daddr(),
	       hdr_ip::access (p2)->dport(), myaddr_);

      recv(p2, 0);
    }

  while (p2 = ll_queue->filter (prte->dst))
    {
      if (verbose_)
      trace ("VRS %.5f %d:%d->%d:%d lost at %d", Scheduler::instance ().clock (),
	       hdr_ip::access (p2)->saddr(),
	       hdr_ip::access (p2)->sport(),
	       hdr_ip::access (p2)->daddr(),
	       hdr_ip::access (p2)->dport(), myaddr_);

      recv (p2, 0);
    }
#endif
}

static void 
mac_callback (Packet * p, void *arg)
{
  ((DSDV_Agent *) arg)->lost_link (p);
}

Packet *
DSDV_Agent::makeUpdate(int& periodic)
    // return a packet advertising the state in the routing table
    // makes a full ``periodic'' update if requested, or a ``triggered''
    // partial update if there are only a few changes and full update otherwise
    // returns with periodic = 1 if full update returned, or = 0 if partial
  //   update returned
	
{
	//DEBUG
	//printf("(%d)-->Making update pkt\n",myaddr_);
	
  Packet *p = allocpkt ();
  hdr_ip *iph = hdr_ip::access(p);
  hdr_cmn *hdrc = HDR_CMN (p);
  double now = Scheduler::instance ().clock ();
  rtable_ent *prte;
  unsigned char *walk;

  int change_count;             // count of entries to go in this update
  int rtbl_sz;			// counts total entries in rt table
  int unadvertiseable;		// number of routes we can't advertise yet

  //printf("Update packet from %d [per=%d]\n", myaddr_, periodic);

  // The packet we send wants to be broadcast
  hdrc->next_hop_ = IP_BROADCAST;
  hdrc->addr_type_ = NS_AF_INET;
  iph->daddr() = IP_BROADCAST << Address::instance().nodeshift();
  iph->dport() = ROUTER_PORT;

  change_count = 0;
  rtbl_sz = 0;
  unadvertiseable = 0;
  for (table_->InitLoop (); 
       (prte = table_->NextLoop ()); )
    {
      rtbl_sz++;
      if ((prte->advert_seqnum || prte->advert_metric) 
	  && prte->advertise_ok_at <= now) 
	change_count++;

      if (prte->advertise_ok_at > now) unadvertiseable++;
    }
  //printf("change_count = %d\n",change_count);
  if (change_count * 3 > rtbl_sz && change_count > 3)
    { // much of the table has changed, just do a periodic update now
      periodic = 1;
    }

  // Periodic update... increment the sequence number...
  if (periodic)
    {
      change_count = rtbl_sz - unadvertiseable;
      //printf("rtbsize-%d, unadvert-%d\n",rtbl_sz,unadvertiseable);
      rtable_ent rte;
      bzero(&rte, sizeof(rte));

      /* inc sequence number on any periodic update, even if we started
	 off wanting to do a triggered update, b/c we're doing a real
	 live periodic update now that'll take the place of our next
	 periodic update */
      seqno_ += 2;

      rte.dst = myaddr_;
      //rte.hop = iph->src();
      rte.hop = Address::instance().get_nodeaddr(iph->saddr());
      rte.metric = 0;
      rte.seqnum = seqno_;

      rte.advertise_ok_at = 0.0; // can always advert ourselves
      rte.advert_seqnum = true;  // always include ourselves in Triggered Upds
      rte.changed_at = now;
      rte.new_seqnum_at = now;
      rte.wst = 0;
      rte.timeout_event = 0;		// Don't time out our localhost :)

      rte.q = 0;		// Don't buffer pkts for self!

      table_->AddEntry (rte);
    }

  if (change_count == 0) 
    {
      Packet::free(p); // allocated by us, no drop needed

      return NULL; // nothing to advertise
    }

  /* ****** make the update packet.... ***********
     with less than 100+ nodes, an update for all nodes is less than the
     MTU, so don't bother worrying about splitting the update over
     multiple packets -dam 4/26/98 */
  //assert(rtbl_sz <= (1500 / 12)); ---how about 100++ node topologies

  p->allocdata((change_count * 9) + 1);
  walk = p->accessdata ();
  *(walk++) = change_count;

  // hdrc->size_ = change_count * 12 + 20;	// DSDV + IP
  hdrc->size_ = change_count * 12 + IP_HDR_LEN;	// DSDV + IP

  for (table_->InitLoop (); (prte = table_->NextLoop ());)
    {

      if (periodic && prte->advertise_ok_at > now)
	{ // don't send out routes that shouldn't be advertised
	  // even in periodic updates
	  continue;
	}

      if (periodic || 
	  ((prte->advert_seqnum || prte->advert_metric) 
	   && prte->advertise_ok_at <= now))
	{ // include this rte in the advert
	  if (!periodic && verbose_)
	    trace ("VCT %.5f _%d_ %d", now, myaddr_, prte->dst);

	  //assert (prte->dst < 256 && prte->metric < 256);
	  //*(walk++) = prte->dst;
	  *(walk++) = prte->dst >> 24;
 	  *(walk++) = (prte->dst >> 16) & 0xFF;
 	  *(walk++) = (prte->dst >> 8) & 0xFF;
 	  *(walk++) = (prte->dst >> 0) & 0xFF;
	  *(walk++) = prte->metric;
	  *(walk++) = (prte->seqnum) >> 24;
	  *(walk++) = ((prte->seqnum) >> 16) & 0xFF;
	  *(walk++) = ((prte->seqnum) >> 8) & 0xFF;
	  *(walk++) = (prte->seqnum) & 0xFF;

	  prte->last_advertised_metric = prte->metric;

	  // seqnum's only need to be advertised once after they change
	  prte->advert_seqnum = false; // don't need to advert seqnum again

	  if (periodic) 
	    { // a full advert means we don't have to re-advert either 
	      // metrics or seqnums again until they change
	      prte->advert_seqnum = false;
	      prte->advert_metric = false;
	    }
	  change_count--;
	}
    }  
  assert(change_count == 0);
  return p;
}

void
DSDV_Agent::updateRoute(rtable_ent *old_rte, rtable_ent *new_rte)
{
  int negvalue = -1;
  assert(new_rte);

  Time now = Scheduler::instance().clock();

  char buf[1024];
  //  snprintf (buf, 1024, "%c %.5f _%d_ (%d,%d->%d,%d->%d,%d->%d,%lf)",
  snprintf (buf, 1024, "%c %.5f _%d_ (%d,%d->%d,%d->%d,%d->%d,%f)",
	    (new_rte->metric != BIG 
	     && (!old_rte || old_rte->metric != BIG)) ? 'D' : 'U', 
	    now, myaddr_, new_rte->dst, 
	    old_rte ? old_rte->metric : negvalue, new_rte->metric, 
	    old_rte ? old_rte->seqnum : negvalue,  new_rte->seqnum,
	    old_rte ? old_rte->hop : -1,  new_rte->hop, 
	    new_rte->advertise_ok_at);

  table_->AddEntry (*new_rte);
  //printf("(%d),Route table updated..\n",myaddr_);
  if (trace_wst_)
    trace ("VWST %.12lf frm %d to %d wst %.12lf nxthp %d [of %d]",
	   now, myaddr_, new_rte->dst, new_rte->wst, new_rte->hop, 
	   new_rte->metric);
  if (verbose_)
    trace ("VS%s", buf);
}

void
DSDV_Agent::processUpdate (Packet * p)
{
  hdr_ip *iph = HDR_IP(p);
  Scheduler & s = Scheduler::instance ();
  double now = s.clock ();
  
  // it's a dsdv packet
  int i;
  unsigned char *d = p->accessdata ();
  unsigned char *w = d + 1;
  rtable_ent rte;		// new rte learned from update being processed
  rtable_ent *prte;		// ptr to entry *in* routing tbl

  //DEBUG
  //int src, dst;
  //src = Address::instance().get_nodeaddr(iph->src());
  //dst = Address::instance().get_nodeaddr(iph->dst());
  //printf("Received DSDV packet from %d(%d) to %d(%d) [%d)]\n", src, iph->sport(), dst, iph->dport(), myaddr_);

  for (i = *d; i > 0; i--)
    {
      bool trigger_update = false;  // do we need to do a triggered update?
      nsaddr_t dst;
      prte = NULL;

      dst = *(w++);
      dst = dst << 8 | *(w++);
      dst = dst << 8 | *(w++);
      dst = dst << 8 | *(w++);

      if ((prte = table_->GetEntry (dst)))
	{
	  bcopy(prte, &rte, sizeof(rte));
	}
      else
	{
	  bzero(&rte, sizeof(rte));
	}

      rte.dst = dst;
      //rte.hop = iph->src();
      rte.hop = Address::instance().get_nodeaddr(iph->saddr());
      rte.metric = *(w++);
      rte.seqnum = *(w++);
      rte.seqnum = rte.seqnum << 8 | *(w++);
      rte.seqnum = rte.seqnum << 8 | *(w++);
      rte.seqnum = rte.seqnum << 8 | *(w++);
      rte.changed_at = now;
      if (rte.metric != BIG) rte.metric += 1;

      if (rte.dst == myaddr_)
	{
	  if (rte.metric == BIG && periodic_callback_)
	    {
	      // You have the last word on yourself...
	      // Tell the world right now that I'm still here....
	      // This is a CMU Monarch optimiziation to fix the 
	      // the problem of other nodes telling you and your neighbors
	      // that you don't exist described in the paper.
	      s.cancel (periodic_callback_);
	      s.schedule (helper_, periodic_callback_, 0);
	    }
	  continue;		// don't corrupt your own routing table.

	}

      /**********  fill in meta data for new route ***********/
      // If it's in the table, make it the same timeout and queue.
      if (prte)
	{ // we already have a route to this dst
	  if (prte->seqnum == rte.seqnum)
	    { // we've got an update with out a new squenece number
	      // this update must have come along a different path
	      // than the previous one, and is just the kind of thing
	      // the weighted settling time is supposed to track.

	      // this code is now a no-op left here for clarity -dam XXX
	      rte.wst = prte->wst;
	      rte.new_seqnum_at = prte->new_seqnum_at;
	    }
	  else 
	    { // we've got a new seq number, end the measurement period
	      // for wst over the course of the old sequence number
	      // and update wst with the difference between the last
	      // time we changed the route (which would be when the 
	      // best route metric arrives) and the first time we heard
	      // the sequence number that started the measurement period

	      // do we care if we've missed a sequence number, such
	      // that we have a wst measurement period that streches over
	      // more than a single sequence number??? XXX -dam 4/20/98
	      rte.wst = alpha_ * prte->wst + 
		(1.0 - alpha_) * (prte->changed_at - prte->new_seqnum_at);
	      rte.new_seqnum_at = now;
	    }
	}
      else
	{ // inititallize the wst for the new route
	  rte.wst = wst0_;
	  rte.new_seqnum_at = now;
	}
	  
      // Now that we know the wst_, we know when to update...
      if (rte.metric != BIG && (!prte || prte->metric != BIG))
	rte.advertise_ok_at = now + (rte.wst * 2);
      else
	rte.advertise_ok_at = now;

      /*********** decide whether to update our routing table *********/
      if (!prte)
	{ // we've heard from a brand new destination
	  if (rte.metric < BIG) 
	    {
	      rte.advert_metric = true;
	      trigger_update = true;
	    }
	  updateRoute(prte,&rte);
	}
      else if ( prte->seqnum == rte.seqnum )
	{ // stnd dist vector case
	  if (rte.metric < prte->metric) 
	    { // a shorter route!
	      if (rte.metric == prte->last_advertised_metric)
		{ // we've just gone back to a metric we've already advertised
		  rte.advert_metric = false;
		  trigger_update = false;
		}
	      else
		{ // we're changing away from the last metric we announced
		  rte.advert_metric = true;
		  trigger_update = true;
		}
	      updateRoute(prte,&rte);
	    }
	  else
	    { // ignore the longer route
	    }
	}
      else if ( prte->seqnum < rte.seqnum )
	{ // we've heard a fresher sequence number
	  // we *must* believe its rt metric
	  rte.advert_seqnum = true;	// we've got a new seqnum to advert
	  if (rte.metric == prte->last_advertised_metric)
	    { // we've just gone back to our old metric
	      rte.advert_metric = false;
	    }
	  else
	    { // we're using a metric different from our last advert
	      rte.advert_metric = true;
	    }

	  updateRoute(prte,&rte);

#ifdef TRIGGER_UPDATE_ON_FRESH_SEQNUM
	  trigger_update = true;
#else
	  trigger_update = false;
#endif
	}
      else if ( prte->seqnum > rte.seqnum )
	{ // our neighbor has older sequnum info than we do
	  if (rte.metric == BIG && prte->metric != BIG)
	    { // we must go forth and educate this ignorant fellow
	      // about our more glorious and happy metric
	      prte->advertise_ok_at = now;
	      prte->advert_metric = true;
	      // directly schedule a triggered update now for 
	      // prte, since the other logic only works with rte.*
	      needTriggeredUpdate(prte,now);
	    }
	  else
	    { // we don't care about their stale info
	    }
	}
      else
	{
	  fprintf(stderr,
		  "%s DFU: unhandled adding a route entry?\n", __FILE__);
	  abort();
	}
      
      if (trigger_update)
	{
	  prte = table_->GetEntry (rte.dst);
	  assert(prte != NULL && prte->advertise_ok_at == rte.advertise_ok_at);
	  needTriggeredUpdate(prte, prte->advertise_ok_at);
	}

      // see if we can send off any packets we've got queued
      if (rte.q && rte.metric != BIG)
	{
	  Packet *queued_p;
	  while ((queued_p = rte.q->deque()))
	  // XXX possible loop here  
	  // while ((queued_p = rte.q->deque()))
	  // Only retry once to avoid looping
	  // for (int jj = 0; jj < rte.q->length(); jj++){
	  //  queued_p = rte.q->deque();
	    recv(queued_p, 0); // give the packets to ourselves to forward
	  // }
	  delete rte.q;
	  rte.q = 0;
	  table_->AddEntry(rte); // record the now zero'd queue
	}
    } // end of all destination mentioned in routing update packet

  // Reschedule the timeout for this neighbor
  prte = table_->GetEntry(Address::instance().get_nodeaddr(iph->saddr()));
  if (prte)
    {
      if (prte->timeout_event)
	s.cancel (prte->timeout_event);
      else
	{
	  prte->timeout_event = new Event ();
	}
      
      s.schedule (helper_, prte->timeout_event, min_update_periods_ * perup_);
    }
  else
    { // If the first thing we hear from a node is a triggered update
      // that doesn't list the node sending the update as the first
      // thing in the packet (which is disrecommended by the paper)
      // we won't have a route to that node already.  In order to timeout
      // the routes we just learned, we need a harmless route to keep the
      // timeout metadata straight.
      
      // Hi there, nice to meet you. I'll make a fake advertisement
      bzero(&rte, sizeof(rte));
      rte.dst = Address::instance().get_nodeaddr(iph->saddr());
      rte.hop = Address::instance().get_nodeaddr(iph->saddr());
      rte.metric = 1;
      rte.seqnum = 0;
      rte.advertise_ok_at = now + 604800;	// check back next week... :)
      
      rte.changed_at = now;
      rte.new_seqnum_at = now;
      rte.wst = wst0_;
      rte.timeout_event = new Event ();
      rte.q = 0;
      
      updateRoute(NULL, &rte);
      s.schedule(helper_, rte.timeout_event, min_update_periods_ * perup_);
    }
  
  /*
   * Freeing a routing layer packet --> don't need to
   * call drop here.
   */
  Packet::free (p);

}

int 
DSDV_Agent::diff_subnet(int dst) 
{
	char* dstnet = Address::instance().get_subnetaddr(dst);
	if (subnet_ != NULL) {
		if (dstnet != NULL) {
			if (strcmp(dstnet, subnet_) != 0) {
				delete [] dstnet;
				return 1;
			}
			delete [] dstnet;
		}
	}
	//assert(dstnet == NULL);
	return 0;
}



void
DSDV_Agent::forwardPacket (Packet * p)	
{

	hdr_cmn *ch  = HDR_CMN(p); //IDRM_SH
  hdr_ip *iph = HDR_IP(p);
  Scheduler & s = Scheduler::instance ();
  double now = s.clock ();
  hdr_cmn *hdrc = HDR_CMN (p);
  rtable_ent *prte;

	//IDRM_SH  
  nsaddr_t dst = iph->daddr();
  //prte = table_->GetEntry (dst); //get an entry

  
	dumpRT(myaddr_);

	if(DSDV_DEBUG){
		// See if it is pointing to a non-zero (no-default) interface. If yes, just invoke the forward routine on the IDRM agent
		printf("[DSDV SH RT] NodeId:%d from %d ptype:%d\n", myaddr_, iph->saddr(), ch->ptype());
	  for (table_->InitLoop (); (prte = table_->NextLoop ());){
	          // check if a route entry is VALID i.e. If it it not expired the sequence of the entry is even, otherwise odd
	          //if( prte->seqnum % 2 == 0 ){
        printf("DSDV ROUTE ENTRY: (Dest, NextHop, HopCount, Iface, changed_at) =(%d,%d,%d,%d,%lf)\n",
                                                prte->dst, prte->hop, prte->metric, prte->rt_interface, prte->changed_at);
	  }
	}

	prte = table_->GetEntry (dst); //get an entry

	//0827
	if(iph->saddr() == myaddr_ && hdrc->ptype() == 2){
		if(prte){
			dsdv_pkt_not_drop++;
			int hops = prte->metric;
			if(hops < 200 && DSDV_DEBUG)
				printf("[DSDV PKT_N_DROP] NodeId: %d dsdv_pkt_n_drop: %d hops: %d at %lf\n", myaddr_, dsdv_pkt_not_drop, hops, CURRENT_TIME);
		}
		else{
			dsdv_pkt_drop++;
		
			if(DSDV_DEBUG)
				printf("[DSDV PKT_DROP] NodeId: %d dsdv_pkt_drop: %d at %lf\n", myaddr_, dsdv_pkt_not_drop, CURRENT_TIME);
		}
	}
	//0827

	if (prte && prte->metric != BIG ) 	//if baseAgent has an entry for dst, send pkt
			goto base;

	//if the baseAgent does not have an entry for dst,
	//lookup IDRM agent: 0709 iIDRM first, then eIDRM
	//if(idrmRAgent){
	if( idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == true)){ //0303
		idrm_rt_entry* rt = ((IDRM *)idrmRAgent)->intra_rt_lookup(iph->daddr());
		if(rt){
			if(DSDV_DEBUG)
				printf("[SH DSDV]NodeId:%d Packet is forward to IDRM for encapsulation at %lf\n", myaddr_, CURRENT_TIME);
			
			((IDRM *)idrmRAgent)->intra_encapsulation(p);


		//0827
			int base_hop_count, idrm_hop_count;
		
			idrm_hop_count = rt->hop_count;
			bool find = false;
		  for (table_->InitLoop (); (prte = table_->NextLoop ());){
				if(prte->dst == iph->saddr() && prte->metric < 200) {
					base_hop_count = prte->metric;
					find = true;
				}
	  	}
	  	int total_hops = base_hop_count + idrm_hop_count;
			if(find)
				printf("[DSDV_IDRM HOP_COUNT] NodeID: %d base_hops: %d idrm_hops: %d total: %d at %lf\n", myaddr_, base_hop_count, idrm_hop_count, total_hops, CURRENT_TIME);
		//0827

			return;
		}
		else{
			if(DSDV_DEBUG)
				printf("[SH DSDV]NodeId:%d iIDRM does not have %d, try eIDRM\n", myaddr_, iph->daddr());	
		}
	
		//if iIDRM does not have it...then ask to eIDRM
		rt = ((IDRM *)idrmRAgent)->rt_lookup(dst);
		
		if( (!prte && rt) || (prte && prte->metric <= 250 && rt) ){//if baseAgent does not have, but IDRM agent has..

			if(DSDV_DEBUG)
				printf("DSDV_check12 NodeId: %d to dst: %d at %lf\n", myaddr_, dst, CURRENT_TIME);

			((IDRM *)idrmRAgent)->forwardFromBaseRoutingAgent(p, 0.0); //delay is set as 0 (??)

			//0827
			idrm_pkt_not_drop++;
			if(DSDV_DEBUG)
				printf("[IDRM PKT_N_DROP] NodeId: %d idrm_pkt_n_drop: %d at %lf\n", myaddr_, idrm_pkt_not_drop, CURRENT_TIME);
			//0827
	
			return;
		}
		else{
			if(DSDV_DEBUG)
				printf("[SH DSDV]NodeId:%d eIDRM does not have %d, ask to GT\n", myaddr_, iph->daddr());	
	
			//0827
			idrm_pkt_drop++;
			if(DSDV_DEBUG)
				printf("[IDRM PKT_DROP] NodeId: %d idrm_pkt_drop: %d at %lf\n", myaddr_, idrm_pkt_drop, CURRENT_TIME);
			//0827

		}
	}
	

base:  
  // We should route it.
  //printf("(%d)-->forwardig pkt\n",myaddr_);
  // set direction of pkt to -1 , i.e downward
  hdrc->direction() = hdr_cmn::DOWN;

  // if the destination is outside mobilenode's domain
  // forward it to base_stn node
  // Note: pkt is not buffered if route to base_stn is unknown

  dst = Address::instance().get_nodeaddr(iph->daddr());  

  //if (diff_subnet(iph->daddr())) { //comment out by IDRM_SH
  
  //IDRM_SH: dst to diff subnet then ask! to my gateway
	if (from_diff_domain(iph->daddr())){  

		if(DSDV_DEBUG)			
			printf("DSDV NodeId:%d dst %d is in diffsubnet\n", myaddr_, iph->daddr());

		/* comment out by IDRM_SH
	   prte = table_->GetEntry (dst);
	  if (prte && prte->metric != BIG) 
		  goto send;
	  
	  //int dst = (node_->base_stn())->address();
	  dst = node_->base_stn();
	  */

	  dst = GetMyGateWay(); 
	
		//0827
		if(dst == -1){
			idrm_gt_drop++;
			if(DSDV_DEBUG)
				printf("[IDRM GT_DROP] NodeId: %d gt_drop: %d at %lf\n", myaddr_, idrm_gt_drop, CURRENT_TIME);
		}
		else{
			idrm_gt_not_drop++;
			if(DSDV_DEBUG)
				printf("[IDRM GT_N_DROP] NodeId: %d gt_n_drop: %d at %lf\n", myaddr_, idrm_gt_not_drop, CURRENT_TIME);
		}
		//0827
		
	  if(DSDV_DEBUG)
		  printf("DSDV NodeId: %d sent to myGT:%d at %lf\n",myaddr_, dst, CURRENT_TIME);
	
	  dumpRT(myaddr_);

	  prte = table_->GetEntry (dst);
	  if (prte && prte->metric != BIG) {

			if(DSDV_DEBUG){
				if(idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == true))
					printf("DSDV_check13 NodeId: %d to dst: %d at %lf\n", myaddr_, dst, CURRENT_TIME);
				else if(idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == false))
					printf("DSDV_check15 NodeId: %d to dst: %d at %lf\n", myaddr_, dst, CURRENT_TIME);
			}

		  goto send;
		}
	  else {
		  //drop pkt with warning
		  //fprintf(stderr, "warning: Route to base_stn not known: dropping pkt\n");
			
			//0305 workingon
			//idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == true
			if(DSDV_DEBUG){
				if(idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == true))
					printf("DSDV_check14 NodeId: %d to dst: %d at %lf\n", myaddr_, dst, CURRENT_TIME);
				else if(idrmRAgent && (((IDRM *)idrmRAgent)->now_gateway == false))
					printf("DSDV_check16 NodeId: %d to dst: %d at %lf\n", myaddr_, dst, CURRENT_TIME);
			}

		  Packet::free(p);
		  return;
	  }
  }
  //IDRM_SH
  
  prte = table_->GetEntry (dst);
  
  //  trace("VDEBUG-RX %d %d->%d %d %d 0x%08x 0x%08x %d %d", 
  //  myaddr_, iph->src(), iph->dst(), hdrc->next_hop_, hdrc->addr_type_,
  //  hdrc->xmit_failure_, hdrc->xmit_failure_data_,
  //  hdrc->num_forwards_, hdrc->opt_num_forwards);

  if (prte && prte->metric != BIG)
    {
       //printf("(%d)-have route for dst\n",myaddr_);
       goto send;
    }
  else if (prte)
    { /* must queue the packet */
	    //printf("(%d)-no route, queue pkt\n",myaddr_);
      if (!prte->q)
	{
	  prte->q = new PacketQueue ();
	}

      prte->q->enque(p);

      if (verbose_)
	trace ("VBP %.5f _%d_ %d:%d -> %d:%d", now, myaddr_, iph->saddr(),
	       iph->sport(), iph->daddr(), iph->dport());

      while (prte->q->length () > MAX_QUEUE_LENGTH)
	      drop (prte->q->deque (), DROP_RTR_QFULL);
      return;
    }
  else
    { // Brand new destination
      rtable_ent rte;
      double now = s.clock();
      
      bzero(&rte, sizeof(rte));
      rte.dst = dst;
      rte.hop = dst;
      rte.metric = BIG;
      rte.seqnum = 0;

      rte.advertise_ok_at = now + 604800;	// check back next week... :)
      rte.changed_at = now;
      rte.new_seqnum_at = now;	// was now + wst0_, why??? XXX -dam
      rte.wst = wst0_;
      rte.timeout_event = 0;

      rte.q = new PacketQueue();
      rte.q->enque(p);
	  
      assert (rte.q->length() == 1 && 1 <= MAX_QUEUE_LENGTH);
      table_->AddEntry(rte);
      
      if (verbose_)
	      trace ("VBP %.5f _%d_ %d:%d -> %d:%d", now, myaddr_,
		     iph->saddr(), iph->sport(), iph->daddr(), iph->dport());
      return;
    }


 send:

	//IDRM_SH 	
  //printf("[SH_TR] NodeId: %d DSDV send from: %d to: %d ptype: %d pid: %d at %lf sp %d dp %d\n", myaddr_, iph->saddr(), iph->daddr(), ch->ptype(), ch->uid(), now,iph->sport(), iph->dport());
	if(ch->ptype() == PT_IDRM){
			struct hdr_idrm *rh =HDR_IDRM(p);
			if(DSDV_DEBUG) printf(" rh->type:%d\n", rh->ih_type);		

	}
	else{
		if(DSDV_DEBUG)
			printf("\n");
	}
	//IDRM_SH
	
  hdrc->addr_type_ = NS_AF_INET;
  hdrc->xmit_failure_ = mac_callback;
  hdrc->xmit_failure_data_ = this;
  if (prte->metric > 1)
	  hdrc->next_hop_ = prte->hop;
  else
	  hdrc->next_hop_ = dst;
  if (verbose_)
	  trace ("Routing pkts outside domain: \
VFP %.5f _%d_ %d:%d -> %d:%d", now, myaddr_, iph->saddr(),
		 iph->sport(), iph->daddr(), iph->dport());  

  assert (!HDR_CMN (p)->xmit_failure_ ||
	  HDR_CMN (p)->xmit_failure_ == mac_callback);
  target_->recv(p, (Handler *)0);
  return;
  
}

void 
DSDV_Agent::sendOutBCastPkt(Packet *p)
{
  Scheduler & s = Scheduler::instance ();
  // send out bcast pkt with jitter to avoid sync
  s.schedule (target_, p, jitter(DSDV_BROADCAST_JITTER, be_random_));
}


void
DSDV_Agent::recv(Packet * p, Handler *)
{

  hdr_ip *iph = HDR_IP(p);
  hdr_cmn *cmh = HDR_CMN(p);
  int src = Address::instance().get_nodeaddr(iph->saddr());


	//IDRM_SH  	
	rtable_ent *prte;
	Time now = Scheduler::instance().clock();
	//IDRM_SH
	
	//IDRM_SH: for demo
	if(IDRM_SH_DEMO_DSDV){
		
		//print my addr and next hop
		//<data time="1" src="0" dst="1" bytes="65431" />	
		//printf("<data time=\"%.0lf\" src=\"%d\" dst=\"%d\" bytes=\"%d\" />\n", now, myaddr_, prte->hop, ch->size());
		if(cmh->size() > 1000 && iph->saddr() != myaddr_)
			printf("<data time= %.0lf src= %d dst= %d bytes= %d />\n", now, iph->saddr(), myaddr_, cmh->size());
	}
	
	if(DSDV_DEBUG){
		printf("[IDRM SH DSDV] NodeId: %d pkt recv from %d ptype: %d pid: %d at %lf\n", myaddr_, iph->saddr(), cmh->ptype(), cmh->uid(), now);
	  printf("[SH_TR] NodeId: %d DSDV recv from: %d to: %d ptype: %d pid: %d at %lf\n", myaddr_, iph->saddr(), iph->daddr(), cmh->ptype(), cmh->uid(), now);
	}
	
	if(cmh->ptype() == 2){
		
		//0821
		if(iph->saddr() == myaddr_) cmh->hop_count =1;
		else cmh->hop_count++;
	
		if(iph->daddr() == myaddr_ || iph->saddr() == myaddr_ )
				printf("[AGENT SH] NodeId: %d receiving UDP from %d pid: %d to %d hops: %d at %lf\n", 
																	myaddr_, iph->saddr(), cmh->uid(), iph->daddr(), cmh->hop_count, now);
	}
	if(cmh->ptype() == PT_IDRM){
		struct hdr_idrm *rh =HDR_IDRM(p);
		if(DSDV_DEBUG)
			printf("[DSDV SH] NodeId:%d receiving IDRMP from %d type:%d at %lf\n", myaddr_, iph->saddr(), rh->ih_type, now);
	}
	
	dumpRT(myaddr_);

  /*
   *  Must be a packet I'm originating...
   */
  if(src == myaddr_ && cmh->num_forwards() == 0) {
    /*
     * Add the IP Header
     */
    cmh->size() += IP_HDR_LEN;    
    iph->ttl_ = IP_DEF_TTL;
  }
  /*
   *  I received a packet that I sent.  Probably
   *  a routing loop.
   */
  else if(src == myaddr_) {
    drop(p, DROP_RTR_ROUTE_LOOP);
    return;
  }
  /*
   *  Packet I'm forwarding...
   */
  else {
    /*
     *  Check the TTL.  If it is zero, then discard.
     */
    if(--iph->ttl_ == 0) {
      drop(p, DROP_RTR_TTL);
      return;
    }
  }
  
  //IDRM_SH
	if((src != myaddr_) && (cmh->ptype() == PT_IDRM)){
		forwardPacket(p);
		return;	
	}
	
  if ((src != myaddr_) && (iph->dport() == ROUTER_PORT))
    {
	    // XXX disable this feature for mobileIP where
	    // the MH and FA (belonging to diff domains)
	    // communicate with each other.

	    // Drop pkt if rtg update from some other domain:
	    // if (diff_subnet(iph->src())) 
	    // drop(p, DROP_OUTSIDE_SUBNET);
	    //else    
	    //processUpdate(p); //comment out by IDRM_SH
	    
		  //IDRM_SH: do not update for a packet from a different MANET
		  if(check_domain_members(iph->saddr()))
		  	processUpdate(p);
			return;
			//IDRM_SH
    }
  else if (iph->daddr() == ((int)IP_BROADCAST) &&
	   (iph->dport() != ROUTER_PORT)) 
	  {
	     if (src == myaddr_) {
		     // handle brdcast pkt
		     sendOutBCastPkt(p);
	     }
	     else {
		     // hand it over to the port-demux
		    port_dmux_->recv(p, (Handler*)0);
	     }
	  }
  else 
    {
	    forwardPacket(p);
    }
}

static class DSDVClass:public TclClass
{
  public:
  DSDVClass ():TclClass ("Agent/DSDV")
  {
  }
  TclObject *create (int, const char *const *)
  {
    return (new DSDV_Agent ());
  }
} class_dsdv;

DSDV_Agent::DSDV_Agent (): Agent (PT_MESSAGE), ll_queue (0), seqno_ (0), 
  myaddr_ (0), subnet_ (0), node_ (0), port_dmux_(0),
  periodic_callback_ (0), be_random_ (1), 
  use_mac_ (0), verbose_ (1), trace_wst_ (0), lasttup_ (-10), 
  alpha_ (0.875),  wst0_ (6), perup_ (15),
  min_update_periods_ (3)	// constants
 {
  table_ = new RoutingTable ();
  helper_ = new DSDV_Helper (this);
  trigger_handler = new DSDVTriggerHandler(this);

  bind_time ("wst0_", &wst0_);
  bind_time ("perup_", &perup_);

  bind ("use_mac_", &use_mac_);
  bind ("be_random_", &be_random_);
  bind ("alpha_", &alpha_);
  bind ("min_update_periods_", &min_update_periods_);
  bind ("verbose_", &verbose_);
  bind ("trace_wst_", &trace_wst_);
  //DEBUG
  address = 0;

	//IDRM_SH
	ifqueue = 0;
  idrmRAgent = NULL;
  //IDRM_SH
   
}

void
DSDV_Agent::startUp()
{
 Time now = Scheduler::instance().clock();

  subnet_ = Address::instance().get_subnetaddr(myaddr_);
  //DEBUG
  address = Address::instance().print_nodeaddr(myaddr_);
  //printf("myaddress: %d -> %s\n",myaddr_,address);
  
  rtable_ent rte;
  bzero(&rte, sizeof(rte));

  rte.dst = myaddr_;
  rte.hop = myaddr_;
  rte.metric = 0;
  rte.seqnum = seqno_;
  seqno_ += 2;

  rte.advertise_ok_at = 0.0; // can always advert ourselves
  rte.advert_seqnum = true;
  rte.advert_metric = true;
  rte.changed_at = now;
  rte.new_seqnum_at = now;
  rte.wst = 0;
  rte.timeout_event = 0;		// Don't time out our localhost :)
  
  rte.q = 0;		// Don't buffer pkts for self!
  
  table_->AddEntry (rte);

  // kick off periodic advertisments
  periodic_callback_ = new Event ();
  Scheduler::instance ().schedule (helper_, 
				   periodic_callback_,
				   jitter (DSDV_STARTUP_JITTER, be_random_));
}

int 
DSDV_Agent::command (int argc, const char *const *argv)
{
  if (argc == 2)
    {
      if (strcmp (argv[1], "start-dsdv") == 0)
	{
		printf ("\n");//IDRM_SH
	  startUp();
	  return (TCL_OK);
	}
      else if (strcmp (argv[1], "dumprtab") == 0)
	{
	  Packet *p2 = allocpkt ();
	  hdr_ip *iph2 = HDR_IP(p2);
	  rtable_ent *prte;

	  printf ("Table Dump %d[%d]\n----------------------------------\n",
		  iph2->saddr(), iph2->sport());
	trace ("VTD %.5f %d:%d\n", Scheduler::instance ().clock (),
		 iph2->saddr(), iph2->sport());

	  /*
	   * Freeing a routing layer packet --> don't need to
	   * call drop here.
	   */
	Packet::free (p2);

	  for (table_->InitLoop (); (prte = table_->NextLoop ());)
	    output_rte ("\t", prte, this);

	  printf ("\n");

	  return (TCL_OK);
	}
      else if (strcasecmp (argv[1], "ll-queue") == 0)
	{
	if (!(ll_queue = (PriQueue *) TclObject::lookup (argv[2])))
	    {
	      fprintf (stderr, "DSDV_Agent: ll-queue lookup of %s failed\n", argv[2]);
	      return TCL_ERROR;
	    }

	  return TCL_OK;
	}

    }
  else if (argc == 3)
    {
      if (strcasecmp (argv[1], "addr") == 0) {
	 int temp;
	 temp = Address::instance().str2addr(argv[2]);
	 myaddr_ = temp;
	 return TCL_OK;
      }
      TclObject *obj;
      if ((obj = TclObject::lookup (argv[2])) == 0)
	{
	  fprintf (stderr, "%s: %s lookup of %s failed\n", __FILE__, argv[1],
		   argv[2]);
	  return TCL_ERROR;
	}
      if (strcasecmp (argv[1], "tracetarget") == 0)
	{
	  
	  tracetarget = (Trace *) obj;
	  return TCL_OK;
	}
      else if (strcasecmp (argv[1], "node") == 0) {
	      node_ = (MobileNode*) obj;
	      return TCL_OK;
      }
      else if (strcasecmp (argv[1], "port-dmux") == 0) {
	      port_dmux_ = (NsObject *) obj;
	      return TCL_OK;
      }
    }
   //IDRM_SH
   else if(argc == 4){
		if(strcmp(argv[1], "idrm_gateway_setup") == 0){
			int index = atoi(argv[2]);
			gateways[index] = atoi(argv[3]);

			printf("%d,", gateways[index]);

			return TCL_OK;
		}
		if(strcmp(argv[1], "idrm_domain_setup") == 0){
			int index = atoi(argv[2]);
			domain_members[index] = atoi(argv[3]);

			printf("D%d,", domain_members[index]);

			return TCL_OK;
		}
	}
	//IDRM_SH	
  else if(argc == 6){
		if(strcmp(argv[1], "idrm_setup") == 0){
			domain							 	= argv[2][0];
			identity 							= atoi(argv[3]);
			num_gateway 					= atoi(argv[4]);
			num_domain_members 		= atoi(argv[5]);
				
			gateways 							= new nsaddr_t[num_gateway];
			domain_members 				= new nsaddr_t[num_domain_members];

			memset(domain_members, -1, sizeof(nsaddr_t) * num_domain_members);

			if(gateway_list == NULL){
				gateway_list					= new bool[num_gateway];	//0303
				memset(gateway_list, 0, sizeof(bool) * num_gateway);
	
				gateway_list2					= new bool[num_gateway];	//0305
				memset(gateway_list2, 0, sizeof(bool) * num_gateway);

				gateway_list3					= new bool[num_gateway];	//0305
				memset(gateway_list3, 0, sizeof(bool) * num_gateway);

				gateway_list4					= new bool[num_gateway];	//0305
				memset(gateway_list4, 0, sizeof(bool) * num_gateway);
			}

			if(myaddr_ < num_domain_members)
				my_gateway_list = gateway_list;
			else
				my_gateway_list = gateway_list2;

			/*
			if(0 <= myaddr && myaddr_ < num_domain_members)
				my_gateway_list = gateway_list;
			eles if(num_domain_members <= myaddr_ && myaddr_ < num_domain_members*2)
				my_gateway_list = gateway_list2;
			else if(num_domain_members*2 <= myaddr && myaddr_ < num_domain_members*3)
				my_gateway_list = gateway_list3;
			else if(num_domain_members*3 <= myaddr && myaddr_ < num_domain_members*4)
				my_gateway_list = gateway_list4;
			*/
				
			//nodes in my domain: will be set at TCL	0615 
			//nodes_domain
			printf("[SH DSDV] Verification:: nodeId:%d domain:%c identity:%d num_gateway:%d my_gateways: ", 
										myaddr_, domain, identity, num_gateway);
										
			if(IDRM_SH_DEMO_DSDV){	//for demo
							
				MobileNode* mynode = (MobileNode*)Node::get_node_by_address(myaddr_);
			
				int mydomain;
				if( domain == 'A' )	mydomain = 0;
				else mydomain = 1;
				
				//format: //<node time="0" id="3" x="400" y="500" gateway="0" domain="1" src="0" dst="1" />	
				printf("\n<node time=\"%.0lf\" id=\"%d\" x=\"%.2f\" y=\"%.2f\" gateway=\"%d\" domain=\"%d\" src=\"%d\" dst=\"%d\" />\n",
							CURRENT_TIME, myaddr_, mynode->X(), mynode->Y(), identity, mydomain, 0, 0);
			}
					return TCL_OK;	
	}
	//IDRM_SH	
}
  return (Agent::command (argc, argv));
}

//0806
void
DSDV_Agent::setifQueue(PriQueue* inQueue){
	ll_queue = inQueue;
}

//IDRM_SH_BEGIN
void
DSDV_Agent::RTUpdateEntryByIDRM(nsaddr_t dst, nsaddr_t nexthop, int hopcount, int seqnum, int iface, nsaddr_t saddr){
	
	Scheduler & s = Scheduler::instance ();
  double now = s.clock ();
  
  rtable_ent rte;			// new rte learned from update being processed
  rtable_ent *prte;		// ptr to entry *in* routing tbl

	//create an entry with the coming data
	rte.dst = dst;
	rte.hop = nexthop;
	rte.metric = hopcount;
	rte.seqnum = seqnum;
	rte.rt_interface = iface; //set IDRM IfaceID	
	rte.new_seqnum_at = now;
	rte.changed_at = now;

	if( (prte = table_->GetEntry(dst)) ){
	//An entry is already exists.
		if( prte->seqnum == rte.seqnum ){
			//the update has the same seqnum, this update comes along a different path than the previous one
			rte.wst = prte->wst;
			rte.new_seqnum_at = prte->new_seqnum_at;
		}
		else{
			rte.wst =  alpha_ * prte->wst + (1-	alpha_) * (prte->changed_at - prte->new_seqnum_at);
			
		}
	}
	else{
	//Add a new entry
		rte.wst = wst0_;
	}

	// Now that we know the wst_, we know when to update...
	if (rte.metric != BIG && (!prte || prte->metric != BIG))
		rte.advertise_ok_at = now + (rte.wst * 2);
	else
		rte.advertise_ok_at = now;

	bool trigger_update = false;
	
  /*********** decide whether to update our routing table *********/
  if (!prte){ // we've heard from a brand new destination
	  if (rte.metric < BIG){
	      rte.advert_metric = true;
	      trigger_update = true;
	   }
	  
	  updateRoute(prte,&rte);
	}
  else if ( prte->seqnum == rte.seqnum ){ // stnd dist vector case
	  if (rte.metric < prte->metric){ // a shorter route!
	     if (rte.metric == prte->last_advertised_metric){ // we've just gone back to a metric we've already advertised
		  		rte.advert_metric = false;
		  		trigger_update = false;
			 }
	     else{ // we're changing away from the last metric we announced
				  rte.advert_metric = true;
				  trigger_update = true;
			 }
	      updateRoute(prte,&rte);
	 }
	 else{ // ignore the longer route
	 }
	}
  else if ( prte->seqnum < rte.seqnum ){
  	// we've heard a fresher sequence number
	  // we *must* believe its rt metric
	  rte.advert_seqnum = true;	// we've got a new seqnum to advert
	  
	  if (rte.metric == prte->last_advertised_metric){
	  	// we've just gone back to our old metric
	    rte.advert_metric = false;
	  }
	  else{ // we're using a metric different from our last advert
	      rte.advert_metric = true;
	  }

	  updateRoute(prte,&rte);

#ifdef TRIGGER_UPDATE_ON_FRESH_SEQNUM
	  trigger_update = true;
#else
	  trigger_update = false;
#endif
	}
  else if ( prte->seqnum > rte.seqnum ){ // our neighbor has older sequnum info than we do
	  if (rte.metric == BIG && prte->metric != BIG){ 
	  		// we must go forth and educate this ignorant fellow
	      // about our more glorious and happy metric
	      prte->advertise_ok_at = now;
	      prte->advert_metric = true;
	      // directly schedule a triggered update now for 
	      // prte, since the other logic only works with rte.*
	      needTriggeredUpdate(prte,now);
	  }
	  else{ // we don't care about their stale info
	  }
	}
  else{
	  fprintf(stderr,
		  "%s DFU: unhandled adding a route entry?\n", __FILE__);
	  abort();
	}
      
  if (trigger_update){
	  prte = table_->GetEntry (rte.dst);
	  assert(prte != NULL && prte->advertise_ok_at == rte.advertise_ok_at);
	  needTriggeredUpdate(prte, prte->advertise_ok_at);
	}

  // see if we can send off any packets we've got queued
  if (rte.q && rte.metric != BIG)
	{
	  Packet *queued_p;
	  while ((queued_p = rte.q->deque()))
	  // XXX possible loop here  
	  // while ((queued_p = rte.q->deque()))
	  // Only retry once to avoid looping
	  // for (int jj = 0; jj < rte.q->length(); jj++){
	  //  queued_p = rte.q->deque();
	    //0709 recv(queued_p, 0); // give the packets to ourselves to forward
	  	forwardPacket(queued_p);
	  // }
	  delete rte.q;
	  rte.q = 0;
	  table_->AddEntry(rte); // record the now zero'd queue
	}
	
  // Reschedule the timeout for this neighbor
  //prte = table_->GetEntry(Address::instance().get_nodeaddr(iph->saddr()));
	prte = table_->GetEntry(saddr);

  if (prte){
  	if (prte->timeout_event)
			s.cancel (prte->timeout_event);
    else{
		  prte->timeout_event = new Event ();
		}

    //0707
  	//if(idrmRAgent){
		if(idrmRAgent && ((IDRM *)idrmRAgent)->now_gateway == true){ //0303
			for(int i=0; i<((IDRM *)idrmRAgent)->n_idrm_rt_entry; i++){
				if( prte->dst == ((IDRM *)idrmRAgent)->idrm_rt_table[i].dst)
					((IDRM *)idrmRAgent)->remove_route(i);	
			}
		}     
     
    s.schedule (helper_, prte->timeout_event, min_update_periods_ * perup_);
  }
  else{ 
  		// If the first thing we hear from a node is a triggered update
      // that doesn't list the node sending the update as the first
      // thing in the packet (which is disrecommended by the paper)
      // we won't have a route to that node already.  In order to timeout
      // the routes we just learned, we need a harmless route to keep the
      // timeout metadata straight.
      
      // Hi there, nice to meet you. I'll make a fake advertisement
      bzero(&rte, sizeof(rte));
      rte.dst = Address::instance().get_nodeaddr(saddr);
      rte.hop = Address::instance().get_nodeaddr(saddr);
      rte.metric = 1;
      rte.seqnum = 0;
      rte.advertise_ok_at = now + 604800;	// check back next week... :)
      
      rte.changed_at = now;
      rte.new_seqnum_at = now;
      rte.wst = wst0_;
      rte.timeout_event = new Event ();
      rte.q = 0;
      
      updateRoute(NULL, &rte);
      s.schedule(helper_, rte.timeout_event, min_update_periods_ * perup_);
    }
}
//IDRM_SH_END

nsaddr_t
DSDV_Agent::GetMyGateWay(){
//return a gatewasy node which is in the shortest hop
 	rtable_ent *prte;
	int hop =100;
	nsaddr_t shortest_gt =-1;
  Scheduler & s = Scheduler::instance ();
	double now = s.clock();
	
	for(int i=0; i<num_gateway; i++){

		//if( gateways[i] == myaddr_ ) continue; //i do not ask to myself
		if( gateways[i] == myaddr_ && my_gateway_list[i] == true ) continue; //i do not ask to myself //when I am gt
		prte	=	table_->GetEntry( gateways[i] );
		
		//if( prte && prte->seqnum % 2 == 0 ){ //exist and valid
		if( prte && prte->seqnum % 2 == 0 && my_gateway_list[i] ){ //exist and valid && currently gateway 0303
			if( prte->metric < hop ){
				shortest_gt = gateways[i];
				hop = prte->metric;	
			}
		}
		
		//for debugging
		if( prte && prte->seqnum % 2 == 0 && my_gateway_list[i] == false ){
			if(DSDV_DEBUG)
				printf("NodeId:%d DSDV returned because %d is not currently gateway at %lf\n", myaddr_, gateways[i], CURRENT_TIME);
		}
	}
	
	if(DSDV_DEBUG){
		printf("NodeId: %d myGT_check: ", myaddr_);
		for(int i=0; i<num_gateway; i++){
			printf("%d | ", my_gateway_list[i]);
		}
		printf("\n");
	
		printf("[IDRM_SH DSDV] NodeId:%d myGT(shortest):%d hop:%d at %lf\n", myaddr_, shortest_gt, hop, now);
	}
	
	//
	/*
	if(shortest_gt != -1)
		printf("[ISO] NodeId: %d success at %lf\n", myaddr_, now);
	else
		printf("[ISO] NodeId: %d fail at %lf\n", myaddr_, now);
	*/
	
	return shortest_gt;
	//return -1; // gateway is not found!... :
}



void
DSDV_Agent::dumpRT(nsaddr_t nodeid){
	if(DSDV_DEBUG){
		
	  rtable_ent *prte;
	  
			printf("[DSDV SH RT] NodeId:%d at %lf \n", myaddr_, CURRENT_TIME);
		  for (table_->InitLoop (); (prte = table_->NextLoop ());){
	      printf("DSDV ROUTE ENTRY: (Dest, NextHop, HopCount, Iface, changed_at) = Myid: %d (%d,%d,%d,%d,%lf) at %lf\n",
	                                      nodeid,  prte->dst, prte->hop, prte->metric, prte->rt_interface, prte->changed_at,CURRENT_TIME );
		  }
	}	
}



//IDRM_SH
bool
DSDV_Agent::from_diff_domain(int dst){ 
	
	rtable_ent *prte;

	for(int i=0; i<num_domain_members; i++){
	
		if(domain_members[i] == -1) exit; //end of the list
	
		//consider domain partition case.. 0807
		prte = table_->GetEntry (dst); //get an entry			
	  if (prte && prte->metric != BIG && domain_members[i] == dst) return false;
		//	if(domain_members[i] == dst) return false; //from my domain

	}
	return true; //from different domain
}
//IDRM_SH

//IDRM_SH
bool
DSDV_Agent::check_domain_members(int dst){

	for(int i=0; i<num_domain_members; i++){
		if(domain_members[i] == dst) return true;
		else if(domain_members[i] == -1) exit;
	}
	
	return false;
}
//IDRM_SH


//IDRM_SH
void
DSDV_Agent::printOverhead(){

	if(DSDV_DEBUG)
	printf("[IDRM DSDV CONTROL] NodeId: %d n_out_pkts: %d s_out_pkts: %d total_n: %d total_s: %d at %lf\n", 
						myaddr_, total_n_control_pkt_dsdv, total_s_control_pkt_dsdv, total_n_control_pkt_dsdv, total_s_control_pkt_dsdv, CURRENT_TIME);
}
//IDRM_SH
